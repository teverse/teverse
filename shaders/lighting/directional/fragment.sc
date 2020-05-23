$input v_texcoord0, lightDirection, lightColour

// 
// Teverse will be rebuilding our PBR shaders shortly
// To optimise fully for Mobile and low end devices
//

#include <teverse.sh>
#include <../../instancedGeometry/lighting.sh>

SAMPLER2D(sColour, 0);
SAMPLER2D(sNormal, 1);
SAMPLER2D(sDepth, 2);

uniform mat4 uniformMtx;
uniform vec4 uniformCameraPosition;

void main()
{
    vec4 colour		= texture2D(sColour, v_texcoord0);
	vec4 normal		= texture2D(sNormal, v_texcoord0);
    normal.xyz      = decodeNormalUint(normal.xyz);
    float depth		= toClipSpaceDepth(texture2D(sDepth, v_texcoord0).x);
	vec3 lightDir	= normalize(-lightDirection);

    float metallic  = colour.w;
    float roughness = normal.w;

    vec3 clip = vec3(v_texcoord0 * 2.0 - 1.0, depth);
#if !GLSL
    clip.y = -clip.y;
#endif 
    vec3 wpos = clipToWorld(uniformMtx, clip);

    vec3 V = normalize(uniformCameraPosition.xyz - wpos);

    vec3 F0 = vec3(0.04); 
    F0 = mix(F0, colour, metallic);
        
    vec3 L = lightDir;
    vec3 H = normalize(V + L);

    // cook-torrance brdf
    float NDF = DistributionGGX(normal.xyz, H, roughness);        
    float G   = GeometrySmith(normal.xyz, V, L, roughness);      
    vec3 F    = fresnelSchlick(max(dot(H, V), 0.0), F0);       
    
    vec3 kS = F;
    vec3 kD = vec3(1.0) - kS;
    kD *= 1.0 - metallic;	  
    
    vec3 numerator    = NDF * G * F;
    float denominator = 4.0 * max(dot(normal.xyz, V), 0.0) * max(dot(normal.xyz, L), 0.0);
    vec3 specular     = numerator / max(denominator, 0.001);  
        
    // add to outgoing radiance Lo
    float NdotL = max(dot(normal.xyz, L), 0.0);                

    gl_FragColor = vec4(((kD * colour / PI + specular) * lightColour * NdotL), 1.0); 
}
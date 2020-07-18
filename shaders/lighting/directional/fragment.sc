$input v_texcoord0, lightDirection, lightColour

// 
// Teverse will be rebuilding our PBR shaders shortly
// To optimise fully for Mobile and low end devices
//

#include <teverse.sh>
#define PI 3.1415926535f

float toClipSpaceDepth(float _depthTextureZ)
{
#if GLSL
	return _depthTextureZ * 2.0 - 1.0;
#else
	return _depthTextureZ;
#endif
}

vec3 clipToWorld(mat4 _invViewProj, vec3 _clipPos)
{
	vec4 wpos = mul(_invViewProj, vec4(_clipPos, 1.0) );
	return wpos.xyz / wpos.w;
}

float DistributionGGX(vec3 N, vec3 H, float roughness)
{
    float a      = roughness*roughness;
    float a2     = a*a;
    float NdotH  = max(dot(N, H), 0.0);
    float NdotH2 = NdotH*NdotH;
	
    float num   = a2;
    float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;
	
    return NdotH2;
}

float GeometrySchlickGGX(float NdotV, float roughness)
{
    float r = (roughness + 1.0);
    float k = (r*r) / 8.0;

    float num   = NdotV;
    float denom = NdotV * (1.0 - k) + k;
	
    return num / denom;
}
float GeometrySmith(vec3 N, vec3 V, vec3 L, float roughness)
{
    float NdotV = max(dot(N, V), 0.0);
    float NdotL = max(dot(N, L), 0.0);
    float ggx2  = GeometrySchlickGGX(NdotV, roughness);
    float ggx1  = GeometrySchlickGGX(NdotL, roughness);
	
    return ggx1 * ggx2;
}

vec3 fresnelSchlick(float cosTheta, vec3 F0)
{
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}  

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

    vec3 F0 = vec3(0.04, 0.04, 0.04); 
    F0 = mix(F0, colour.xyz, metallic);
        
    vec3 L = lightDir;
    vec3 H = normalize(V + L);

    // cook-torrance brdf
    float NDF = DistributionGGX(normal.xyz, H, roughness);        
    float G   = GeometrySmith(normal.xyz, V, L, roughness);      
    vec3 F    = fresnelSchlick(max(dot(H, V), 0.0), F0);       
    
    vec3 kS = F;
    vec3 kD = vec3(1.0, 1.0, 1.0) - kS;
    kD *= 1.0 - metallic;	  
    
    vec3 numerator    = NDF * G * F;
    float denominator = 4.0 * max(dot(normal.xyz, V), 0.0) * max(dot(normal.xyz, L), 0.0);
    vec3 specular     = numerator / max(denominator, 0.001);  
        
    // add to outgoing radiance Lo
    float NdotL = max(dot(normal.xyz, L), 0.0);                

    gl_FragColor = vec4(((kD * colour.xyz / PI + specular) * lightColour * NdotL), colour.w); 
}
$input v_worldPos, v_view, v_normal, v_tangent, v_bitangent, v_color0, v_color1

#include <teverse.sh>
#include <lighting.sh>

uniform vec4 u_lightRgbInnerR;
uniform vec4 u_camPos;

void main()
{
	float roughness = v_color1.y;
	float metalness = v_color1.x;

	GBufferData buffer;
	buffer.base_color = v_color0.xyz;
	buffer.ambient_occlusion = 11.0;
	buffer.world_normal = v_normal.xyz;
	buffer.roughness = roughness;
	buffer.emissive_color = vec3(0.0, 0.0, 0.0);
	buffer.metalness = metalness;
	buffer.subsurface_color = vec3(1.0, 1.0, 1.0);
	buffer.subsurface_opacity = 0.0;

	vec4 result[3];
	encodeGBuffer(buffer, result);
	gl_FragData[0] = result[0]; 
	gl_FragData[1] = result[1];
	gl_FragData[2] = result[2];
}
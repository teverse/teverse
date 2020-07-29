$input a_position, a_normal, a_weight, a_indices
$output v_normal, v_colour, v_position, v_pbr

#include <teverse.sh>
#include <teverse_compute.sh>

uniform mat3 normalMatrix;
uniform vec4 colour;
uniform vec4 pbr;
uniform mat4 jointMatrix[90];

void main()
{
	// metalness, roughness, 0, 0
	v_pbr = pbr;

	mat4 model = (
		a_weight.x * jointMatrix[int(a_indices.x)] + 
		a_weight.y * jointMatrix[int(a_indices.y)] +
		a_weight.z * jointMatrix[int(a_indices.z)] +
		a_weight.w * jointMatrix[int(a_indices.w)]
	);

	vec4 wpos = mul(model, vec4(a_position, 1.0));
	gl_Position = mul(u_modelViewProj, wpos);

	//gl_Position = mul(u_modelViewProj, vec4(a_position, 1.0));

	vec3 normal = a_normal.xyz * 2.0 - 1.0;
	vec3 wnormal = instMul(normalMatrix, normal.xyz);
	v_normal = encodeNormalUint(normalize(wnormal.xyz));
	v_colour = colour;
	v_position = gl_Position.xyz;
}
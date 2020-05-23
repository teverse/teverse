$input a_position, a_texcoord0, i_data0, i_data1
$output v_texcoord0, lightDirection, lightColour

#include <teverse.sh>

void main()
{
	gl_Position = mul(u_modelViewProj, vec4(a_position, 1.0) );
	v_texcoord0 = a_texcoord0;
	lightColour = i_data0.xyz;
	lightDirection = i_data1.xyz;
}
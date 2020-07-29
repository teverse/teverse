$input v_normal, v_colour, v_position, v_pbr

#include <teverse.sh>

uniform vec4 uniformCameraPosition;

void main()
{
	gl_FragData[0] = vec4(v_colour.xyz, v_pbr.x);
	gl_FragData[1] = vec4(v_normal, v_pbr.y);
	//gl_FragData[2] = vec4(v_position, 0.0);
}
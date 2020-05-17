$input v_worldPos, v_view, v_normal, v_tangent, v_bitangent, v_color0, v_color1

#include <teverse.sh>
#include <lighting.sh>

uniform vec4 u_lightRgbInnerR;
uniform vec4 u_camPos;

void main()
{
	gl_FragColor = vec4(encodeNormalUint(v_normal), 0.0);
}
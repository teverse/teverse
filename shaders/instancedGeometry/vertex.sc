$input a_position, a_normal, a_tangent, a_color0, i_data0, i_data1, i_data2, i_data3, i_data4, a_texcoord2
$output v_worldPos, v_view, v_normal, v_tangent, v_bitangent, v_color0, v_color1

/*
 * Portions of this file may have been directly taken or adapted from the following open sourced projects:
 *
 * Copyright 2011-2019 Branimir Karadzic. All rights reserved.
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 *
 */

#include <teverse.sh>

void main()
{
	mat4 model;
	model[0] = i_data0;
	model[1] = i_data1;
	model[2] = i_data2;
	model[3] = i_data3;

	vec3 wpos = instMul(model, vec4(a_position, 1.0) ).xyz;
	gl_Position = mul(u_viewProj, vec4(wpos, 1.0) );
	v_worldPos = wpos;

	mat3 modelIT = calculateInverseTranspose(u_model[0]);

	vec4 normal = a_normal * 2.0 - 1.0;
	vec4 tangent = a_tangent * 2.0 - 1.0;

	vec3 wnormal = normalize(mul(modelIT, normal.xyz ));
	vec3 wtangent = normalize(mul(modelIT, tangent.xyz ));

	vec3 view = mul(u_view, vec4(wpos, 0.0) ).xyz;
	v_view = view; //mul(view, tbn);

	v_normal    = normalize(wnormal);
	v_tangent   = wtangent;
	v_bitangent = vec3(0.0, 0.0, 0.0);

	//v_position = a_position;

	v_color0 = i_data4;
	v_color1 = a_texcoord2;
}
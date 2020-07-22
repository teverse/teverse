$input a_position, a_normal, i_data0, i_data1, i_data2, i_data3, i_data4
$output v_normal, v_colour, v_position, v_pbr

/*
 * Portions of this file may have been directly taken or adapted from the following open sourced projects:
 *
 * Copyright 2011-2019 Branimir Karadzic. All rights reserved.
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 *
 */

#include <teverse.sh>
#include <teverse_compute.sh>

BUFFER_RO(normalData, vec4, 2);

void main()
{
	mat4 model;
	model[0] = i_data0;
	model[1] = i_data1;
	model[2] = i_data2;
	model[3] = i_data3;

	// metalness, roughness, 0, 0
	v_pbr = vec4(normalData[gl_InstanceID * 3].w, i_data4.w, 0.0, 0.0);

	mat3 normalMatrix;
	normalMatrix[0] = normalData[gl_InstanceID * 3].xyz;
	normalMatrix[1] = normalData[gl_InstanceID * 3 + 1].xyz;
	normalMatrix[2] = normalData[gl_InstanceID * 3 + 2].xyz;
	
	vec3 wpos = instMul(model, vec4(a_position, 1.0) ).xyz;
	gl_Position = mul(u_viewProj, vec4(wpos, 1.0) );

	vec3 normal = a_normal.xyz * 2.0 - 1.0;
	vec3 wnormal = instMul(normalMatrix, normal.xyz);
	v_normal = encodeNormalUint(normalize(wnormal.xyz));
	v_colour = i_data4;
	v_position = gl_Position.xyz;
}
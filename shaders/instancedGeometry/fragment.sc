$input v_worldPos, v_view, v_normal, v_tangent, v_bitangent, v_color0, v_position

#include <teverse.sh>

/*
 * Portions of this file may have been directly taken or adapted from the following open sourced projects:
 *
 * Copyright 2011-2019 Branimir Karadzic. All rights reserved.
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 *
 */

uniform vec4 u_lightRgbInnerR;
uniform vec4 u_materialInfo;
uniform vec4 u_camPos;
uniform mat4 u_normalMatrix;

float remapRoughness(float x)
{
  return 2.0f * (1.0f / (1.0f - 0.5f + 0.001f) - 1.0f) * (pow(x, 2)) + 0.001f;
}

float schlick(float R0, float cos_theta)
{
  float R = R0 + (1.0 - R0) * pow((1.0 - cos_theta), 5.0);
  return R;
}

float roughSchlick2(float R0, float cos_theta, float roughness)
{
  float area_under_curve = 1.0 / 6.0 * (5.0 * R0 + 1.0);
  float new_area_under_curve = 1.0 / (6.0 * roughness + 6.0) * (5.0 * R0 + 1.0);

  return schlick(R0, cos_theta) /
    (1.0 + roughness) + (area_under_curve - new_area_under_curve);
}


void main()
{
	vec3 normal = v_tangent + v_bitangent + v_normal;

	vec3 wnormal = normalize(mul(mul(u_invView, vec4(v_normal,0.0) ), u_normalMatrix)).xyz;

	vec3 view = mul(u_view, vec4(v_worldPos, 0.0) ).xyz;
	view = normalize(view);

	vec3 v = normalize(u_camPos.xyz-view);
	float cos_theta = max(dot(normalize(v_position), wnormal),  0.0f);
	float remapped_roughness = remapRoughness(u_materialInfo.y);
	float fresnel_term = roughSchlick2(0.04, cos_theta, remapped_roughness);
	
	gl_FragData[0] = vec4(u_lightRgbInnerR.xyz, fresnel_term); 
	gl_FragData[1] = vec4(wnormal, 1.0);
	gl_FragData[2] = u_materialInfo;
}
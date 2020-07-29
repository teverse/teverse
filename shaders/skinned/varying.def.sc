vec3 v_view      : TEXCOORD1 = vec3(0.0, 0.0, 0.0);
vec3 v_position  : TEXCOORD2 = vec3(0.0, 0.0, 0.0);
vec4 v_colour    : TEXCOORD3 = vec4(0.0, 0.0, 0.0, 0.0);
vec4 v_pbr       : TEXCOORD4 = vec4(0.0, 0.0, 0.0, 0.0);
vec3 v_normal    : NORMAL    = vec3(0.0, 0.0, 1.0);

vec3 a_position  : POSITION;
vec4 a_normal    : NORMAL;
vec4 a_weight    : BLENDWEIGHT;
vec4 a_indices   : BLENDINDICES;
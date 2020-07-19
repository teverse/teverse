$input v_texcoord0

#include <teverse.sh>

SAMPLER2D(sColour, 0);
SAMPLER2D(sLight, 1);
uniform vec4 uniformAmbientColour;

vec3 colourAt(vec2 coord){
	vec4 colour  = toLinear(texture2D(sColour, coord) );
	vec4 light   = toLinear(texture2D(sLight,  coord) );
	return toGamma((colour * light) +  (colour * uniformAmbientColour)).xyz;
}

void main()
{
	gl_FragColor = vec4(colourAt(v_texcoord0), texture2D(sColour, v_texcoord0).w);
}
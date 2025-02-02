#version 410

layout(vertices = 4) out;

out vec4 posTC[];

uniform float level;

void main() {

	posTC[gl_InvocationID] = gl_in[gl_InvocationID].gl_Position;
	
	if (gl_InvocationID == 0) {
		gl_TessLevelOuter[0] = level;
		gl_TessLevelOuter[1] = level;
		gl_TessLevelOuter[2] = level;
		gl_TessLevelOuter[3] = level;
		gl_TessLevelInner[0] = level;
		gl_TessLevelInner[1] = level;
	}
}
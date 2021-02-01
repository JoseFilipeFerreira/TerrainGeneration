#version 410

layout(quads, equal_spacing, ccw) in;

uniform	mat4 m_pvm;
uniform sampler2D noise;
uniform sampler2D normals;
uniform	float scale;

in vec4 posTC[];

out Data {
    float height;
    vec4 normal;
} DataOut;

void main() {

	float u = gl_TessCoord.x;
	float v = gl_TessCoord.y;
	float w = 1 - u - v;
	
	vec4 p1 = mix(posTC[0],posTC[1],u);
	vec4 p2 = mix(posTC[3],posTC[2],u);
    vec4 pos = mix(p1, p2, v);
    DataOut.height = texture(noise, pos.xz).x;
    pos.y = DataOut.height * scale;
	gl_Position = m_pvm * pos;
    DataOut.normal = texture(normals,pos.xz);
}
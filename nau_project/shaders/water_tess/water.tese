#version 410

layout(quads, equal_spacing, ccw) in;

uniform	mat4 m_pvm;
uniform	float scale;
uniform float water_level;
uniform float timer;
uniform sampler2D noise;

in vec4 posTC[];

out Data {
    float terrain_height;
    float water_height;
    vec4 normal;
} DataOut;

void main() {

	float u = gl_TessCoord.x;
	float v = gl_TessCoord.y;
	float w = 1 - u - v;
	
	vec4 p1 = mix(posTC[0],posTC[1],u);
	vec4 p2 = mix(posTC[3],posTC[2],u);
    vec4 pos = mix(p1, p2, v);

    DataOut.water_height = sin(pos.z * 10 + timer / 1000) * 0.01 + water_level;
    // Gerstner Waves
    // float k =  10;
    // float c = sqrt(9.8/k);
    // float X = pos.x + pow(2.71828, pos.z * k) / k * cos(k*(pos.x + c * timer / 2000)) * 0.1;
    // float Y = pos.z - pow(2.71828, pos.z * k) / k * cos(k*(pos.x + c * timer / 2000)) * 0.1;

    // DataOut.water_height = X;


    pos.y = DataOut.water_height;
	gl_Position = m_pvm * pos;
    DataOut.normal = vec4(0,1,0,0);
    DataOut.terrain_height = 	texture(noise, pos.xz).x * scale;
}
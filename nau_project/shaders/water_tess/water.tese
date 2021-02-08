#version 410

layout(quads, equal_spacing, ccw) in;

uniform	mat4 m_pvm;
uniform mat3 normal_matrix;

uniform	float scale;
uniform float width;
uniform float water_level;
uniform float timer;
uniform sampler2D noise;

in vec4 posTC[];

out Data {
    float terrain_height;
    float water_height;
    vec4 normal;
} DataOut;

float height_calculator(float px, float pz){
    return
      sin((px + pz) * 10 + timer / 1000) * 0.01
    + sin(pz * 20 + timer / 500) * 0.001
    + sin(px * 15 + timer / 500 + 200) * 0.002
    + water_level;
}

void main() {

	float u = gl_TessCoord.x;
	float v = gl_TessCoord.y;
	float w = 1 - u - v;
	
	vec4 p1 = mix(posTC[0],posTC[1],u);
	vec4 p2 = mix(posTC[3],posTC[2],u);
    vec4 pos = mix(p1, p2, v);

    // Gerstner Waves
    // float k =  10;
    // float c = sqrt(9.8/k);
    // float X = pos.x + pow(2.71828, pos.z * k) / k * cos(k*(pos.x + c * timer / 2000)) * 0.1;
    // float Y = pos.z - pow(2.71828, pos.z * k) / k * cos(k*(pos.x + c * timer / 2000)) * 0.1;

    // DataOut.water_height = X;

    float c  = height_calculator(pos.x, pos.z);
    float x1 = height_calculator(pos.x - 1, pos.z);
    float x2 = height_calculator(pos.x + 1, pos.z);
    float z1 = height_calculator(pos.x, pos.z - 1);
    float z2 = height_calculator(pos.x, pos.z + 1);

    float x = ((x1-c)+(c-x2)) * scale;
    float z = ((z1-c)+(c-z2)) * scale;
    float y = sqrt(1-pow(x,2)-pow(z,2));

    DataOut.normal = vec4( normalize(normal_matrix * vec3(x,y,z)) ,0.0);
    DataOut.water_height = c;
    DataOut.terrain_height = texture(noise, pos.xz).x;

    pos.y = c * scale;
    pos.x = pos.x * width;
    pos.z = pos.z * width;


    gl_Position = m_pvm * pos;
}
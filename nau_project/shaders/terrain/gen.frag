#version 420

uniform mat4 view_matrix;
uniform vec4 light_dir;
uniform vec4 diffuse;

in Data {
	vec4 square_normal;
} DataIn;

out vec4 colorOut;

void main() 
{
	float intensity;
	vec3 n, l;

	l = normalize(vec3(view_matrix * -light_dir));
	n = normalize(DataIn.square_normal.xyz);
	intensity = max(dot(l,n),0.0);

	colorOut = (diffuse * intensity) + diffuse * 0.2;
	//colorOut = vec4(1, 0.0, 0.0, 0);
}
#version 410

uniform mat4 view_matrix;
uniform vec3 light_dir;
out vec4 colorOut;

in Data {
    float terrain_height;
	float water_height;
    vec4 normal;
} DataIn;

void main()
{
	vec3 n = normalize(DataIn.normal.xyz);
	vec3 l = normalize(vec3(view_matrix * -vec4(light_dir, 0.0)));
	float intensity = max(dot(n,l), 0.0);

    // Color constants:
	vec4 deep_water      = vec4(0.243, 0.376, 0.729,1);
	vec4 water           = vec4(0.368, 0.494, 1,1);
	vec4 foam            = vec4(1.0, 1.0, 1.0, 1.0);
	
	vec4 height_color;

	float heigh_difference = abs(DataIn.water_height - DataIn.terrain_height);

	if  (DataIn.water_height <= DataIn.terrain_height) {
		height_color = foam;
	} else if (heigh_difference < 0.1) {
		height_color = mix(foam, water, heigh_difference/0.1);
	} else {
		height_color = mix(deep_water, water, (DataIn.water_height - 0.1) * (1/0.1));
	}

    colorOut = (height_color * intensity) + height_color * 0.2;
}
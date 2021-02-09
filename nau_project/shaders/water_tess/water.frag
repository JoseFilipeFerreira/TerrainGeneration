#version 410

uniform samplerCube texUnit;

uniform mat4 view_matrix;
uniform vec3 light_dir;
uniform float foam_cutoff_height;
out vec4 colorOut;

in Data {
    float terrain_height;
	float water_height;
    vec4 normal;
    vec3 eye_dir;
} DataIn;

void main()
{
	vec3 n = normalize(DataIn.normal.xyz);
	vec3 l = normalize(vec3(view_matrix * -vec4(light_dir, 0.0)));
	float intensity = max(dot(n,l), 0.0);

	vec3 e = normalize(DataIn.eye_dir);
	vec3 t = reflect(e, n);
	vec3 ref = texture(texUnit, t).rgb;

    // Color constants:
	vec4 water           = vec4(ref, 1.0); //vec4(0.368, 0.494, 1, 1.0);
	vec4 foam            = vec4(1.0, 1.0, 1.0, 1.0);
	
	

	vec4 height_color = water;

	float height_difference = abs(DataIn.water_height - DataIn.terrain_height);

	if (DataIn.water_height <= DataIn.terrain_height) 
	{
		height_color = vec4(1,1,1,1);
	} 
	else if (height_difference < foam_cutoff_height) 
	{
		height_color = mix(foam, water, height_difference/foam_cutoff_height);
	}

	

    colorOut = (height_color * intensity) + height_color * 0.2;
	//colorOut = vec4(ref, 1.0);
}
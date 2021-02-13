#version 410

uniform samplerCube texUnit;

uniform mat4 view_matrix;
uniform vec4 light_dir;
uniform float foam_cutoff_height;
uniform float light_slope;
uniform float water_reflection;

out vec4 colorOut;


in Data {
    float terrain_height;
	float water_height;
    vec4 normal;
    vec3 eye_dir;
} DataIn;

vec4 to_cartesian(vec4 dir) {
	float x = dir.x * cos(dir.y);
	float y = dir.x * sin(dir.y);
	return vec4(x,y,dir.z,dir.w);
}

vec4 to_cylindrical(vec4 dir) {
	float r = sqrt(pow(dir.x,2) + pow(dir.y,2) + pow(dir.z,2));
	float theta = atan(dir.y,dir.x);
	return vec4(r,theta,dir.z,dir.w);
}

void main()
{
	vec4 true_light_dir = to_cylindrical(light_dir);
	true_light_dir.y += light_slope;
	
	vec3 n = normalize(DataIn.normal.xyz);
	vec3 l = normalize(vec3(view_matrix * -true_light_dir));
	float intensity = max(dot(n,l), 0.0) * 0.7;

	vec3 e = normalize(DataIn.eye_dir);
	vec3 t = reflect(e, n);
	vec3 ref = texture(texUnit, t).rgb;
	vec4 water_ref = vec4(ref, 1.0);

    // Color constants:
	vec4 water = vec4(0, 0.329, 0.576, 1.0);	
	vec4 foam  = vec4(1.0, 1.0, 1.0, 1.0);



	
	vec4 height_color = mix(water, water_ref, water_reflection);

	float height_difference = abs(DataIn.water_height - DataIn.terrain_height);

	if (DataIn.water_height <= DataIn.terrain_height) 
	{
		height_color = vec4(1,1,1,1);
	} 
	else if (height_difference < foam_cutoff_height) 
	{
		height_color = mix(foam, height_color, height_difference/foam_cutoff_height);
	}

	

    colorOut = (height_color * intensity) + height_color * 0.2;
	//colorOut = vec4(ref, 1.0);
}
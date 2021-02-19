#version 410

uniform mat4 view_matrix;
uniform vec4 light_dir;
uniform float water_level;

uniform float light_slope;

out vec4 colorOut;

in Data {
    float height;
    vec4 normal;
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
    float intensity;
	vec3 n, l;

	vec4 true_light_dir = to_cylindrical(light_dir);
	true_light_dir.y += light_slope;


	l = normalize(vec3(view_matrix * -true_light_dir));
	n = normalize(DataIn.normal.xyz);
	intensity = max(dot(l,n),0.0);


    float height = DataIn.height;
    vec4 height_color;
    
    // Color constants:
	vec4 rock            = vec4(0.582, 0.551, 0.520,1);
	vec4 sand            = vec4(0.761, 0.698, 0.502,1);
	vec4 lower_forest    = vec4(0.224, 0.259, 0.106, 1);
	vec4 forest          = vec4(0.239, 0.501, 0.403,1);
	vec4 lower_mountain  = vec4(0.647, 0.745, 0.494,1);
	vec4 middle_mountain = vec4(0.772, 0.847, 0.729,1);
	vec4 high_mountain   = vec4(1, 1, 1, 1);

/*
	vec4 lower_mountain  = vec4(161/255, 164/255, 68/255 , 1);
	vec4 middle_mountain = vec4(200/255, 192/255, 189/255, 1);
	vec4 high_mountain   = vec4(80/255 , 86/255 , 101/255, 1);
*/
	float steps = (1 - water_level) / 4;
    
	if (height < water_level / 2) // DEEP WATER
	{
		height_color = mix(rock, sand, height/(water_level/2));
	}
	if (height < water_level) // UNDER WATER
	{
		height_color = mix(sand, lower_forest, (height - water_level/2)/(water_level/2));
	}
	else if (height < water_level + steps) // WATER LINE
	{
		height_color = mix(lower_forest, forest, (height - water_level)  / steps);
	}
  	else if (height < water_level + steps * 2) // LOWER MOUNTAIN
	{
		height_color = mix(forest, lower_mountain, (height - water_level - steps) / steps);
	}
  	else if (height < water_level + steps * 3) // MIDDLE MOUNTAIN
	{
		height_color = mix(lower_mountain, middle_mountain, (height - water_level - 2 * steps) / steps);
	}
  	else // HIGH MOUNTAIN
	{
		height_color = mix(middle_mountain, high_mountain, (height - water_level - 3 * steps) / steps);
	}

    colorOut = (height_color * intensity) + height_color * 0.2;
}
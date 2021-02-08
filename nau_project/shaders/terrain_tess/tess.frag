#version 410

uniform mat4 view_matrix;
uniform vec4 light_dir;
uniform float water_level;
out vec4 colorOut;

in Data {
    float height;
    vec4 normal;
} DataIn;

void main()
{
    float intensity;
	vec3 n, l;

	l = normalize(vec3(view_matrix * -light_dir));
	n = normalize(DataIn.normal.xyz);
	intensity = max(dot(l,n),0.0);


    float height = DataIn.height;
    vec4 height_color;
    
    // Color constants:
	vec4 rock            = vec4(0.582, 0.551, 0.520,1);
	vec4 sand            = vec4(0.761, 0.698, 0.502,1);
	vec4 forest          = vec4(0.239, 0.501, 0.403,1);
	vec4 lower_mountain  = vec4(0.647, 0.745, 0.494,1);
	vec4 middle_mountain = vec4(0.772, 0.847, 0.729,1);
	vec4 high_mountain   = vec4(0.835, 0.827, 0.839,1);
    
	if (height < water_level) // UNDER WATER
	{
		height_color = mix(rock, sand, height/water_level);
	}
  	else if (height < 0.3) // LAND
	{
		height_color = mix(sand, forest, (height - 0.2) * (1/0.1));
	}
  	else if (height < 0.7) // LOWER MOUNTAIN
	{
		height_color = mix(forest, lower_mountain, (height - 0.5) * (1/0.2));
	}
  	else if (height < 0.9) // MIDDLE MOUNTAIN
	{
		height_color = mix(lower_mountain, middle_mountain, (height - 0.7) * (1/0.2));
	}
  	else // HIGH MOUNTAIN
	{
		height_color = mix(middle_mountain, high_mountain, (height - 0.9) * (1/0.1));
	}

    colorOut = (height_color * intensity) + height_color * 0.2;
}
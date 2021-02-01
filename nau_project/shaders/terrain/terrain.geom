#version 330

layout(points) in;
layout (triangle_strip, max_vertices=4) out;

uniform sampler2D noise;
uniform mat4 m_pvm;
uniform float scale;
uniform int tesselation;
uniform float width;

out Data {
    vec2 pos;
    vec4 square_normal;
} DataOut;

void main()
{
    // Vertices
    vec4 p[4];
    // Normals
    vec4 n[4];

    vec4 pos = gl_in[0].gl_Position;

    // Certers refer to the position each
    // vertex of a square generated for 
    // each geometry shader
    vec2 centers[4];
    centers[0] = pos.xz + vec2(0,0);
    centers[1] = pos.xz + vec2(0,1);
    centers[2] = pos.xz + vec2(1,0);
    centers[3] = pos.xz + vec2(1,1);

    //float scale_x = 0.1;
    //float scale_z = 0.1;

    p[0] = vec4(((pos.x    )/tesselation)*width, scale*texture(noise, centers[0] / tesselation).x, ((pos.z    )/tesselation)*width, 1);
    p[1] = vec4(((pos.x    )/tesselation)*width, scale*texture(noise, centers[1] / tesselation).x, ((pos.z + 1)/tesselation)*width, 1);
    p[2] = vec4(((pos.x + 1)/tesselation)*width, scale*texture(noise, centers[2] / tesselation).x, ((pos.z    )/tesselation)*width, 1);
    p[3] = vec4(((pos.x + 1)/tesselation)*width, scale*texture(noise, centers[3] / tesselation).x, ((pos.z + 1)/tesselation)*width, 1);

    
    
    for (int i = 0; i < 4; ++i)
    {
        //// X Lower bound condition
        float xlbc = (centers[i].x == 0)   ? 0 : 1;
        //// X Higher bound condition
        float xhbc = (centers[i].x >= tesselation) ? 0 : 1;
        //// Y Lower bound condition
        float ylbc = (centers[i].y == 0)   ? 0 : 1;
        //// Y Higher bound condition
        float yhbc = (centers[i].y >= tesselation) ? 0 : 1;

        float c  = texture(noise, vec2(centers[i].x     ,centers[i].y     ) / tesselation).x;
        float x1 = texture(noise, vec2(centers[i].x-xlbc,centers[i].y     ) / tesselation).x;
        float x2 = texture(noise, vec2(centers[i].x+xhbc,centers[i].y     ) / tesselation).x;
        float z1 = texture(noise, vec2(centers[i].x     ,centers[i].y-ylbc) / tesselation).x;
        float z2 = texture(noise, vec2(centers[i].x     ,centers[i].y+yhbc) / tesselation).x;

        float x = ((x1-c)+(c-x2))*scale;
        float z = ((z1-c)+(c-z2))*scale;
        float y = sqrt(1-pow(x,2)-pow(z,2));
        n[i] = normalize(vec4(x,y,z,0));

	    gl_Position = m_pvm * (p[i]);
        //DataOut.square_normal = normalize( vec4((c-x1)+(x2-c) , 1 , (c-z1)+(z2-c) , 0) );
        DataOut.square_normal = n[i];
        DataOut.pos = centers[i];
        //DataOut.square_normal = vec4(0,1,0,0);
        EmitVertex();
    }
    
    EndPrimitive();
}


#version 410

layout(vertices = 4) out;

out vec4 posTC[];

uniform float level;
uniform float cam_pos_x;

void main() 
{
    posTC[gl_InvocationID] = gl_in[gl_InvocationID].gl_Position;

    //vec4 cam_pos = vec4(cam_pos_x,cam_pos_x,cam_pos_x,1);
    vec4 cam_pos = vec4(1,0,0,1);

    //float dist0 = length(cam_pos.xyz - gl_in[gl_InvocationID].gl_Position.xyz);
    //float dist1 = length(cam_pos.xyz - gl_in[gl_InvocationID+1].gl_Position.xyz);
    //float dist2 = length(cam_pos.xyz - gl_in[gl_InvocationID+2].gl_Position.xyz);
    //float dist3 = length(cam_pos.xyz - gl_in[gl_InvocationID+3].gl_Position.xyz);

    //float tlevel0 = 1 / (0.25*dist0 + (1/64)) + 1;
    //float tlevel1 = 1 / (0.25*dist1 + (1/64)) + 1;
    //float tlevel2 = 1 / (0.25*dist2 + (1/64)) + 1;
    //float tlevel3 = 1 / (0.25*dist3 + (1/64)) + 1;

    //float dist = length(cam_pos.xyz - posTC[gl_InvocationID].xyz);
    //float tlevel = 1 / (0.25*dist + (1/64)) + 1;
    // 1 / (x + (1/64))

    if (gl_InvocationID == 0) 
    {
        gl_TessLevelOuter[0] = level; //tlevel0;
        gl_TessLevelOuter[1] = level; //tlevel1;
        gl_TessLevelOuter[2] = level; //tlevel2;
        gl_TessLevelOuter[3] = level; //tlevel3;
        gl_TessLevelInner[0] = level; //tlevel0;
        gl_TessLevelInner[1] = level; //tlevel0;
    }

    //if (gl_InvocationID == 0) 
    //{
    //    gl_TessLevelOuter[0] = level;
    //    gl_TessLevelOuter[1] = level;
    //    gl_TessLevelOuter[2] = level;
    //    gl_TessLevelOuter[3] = level;
    //    gl_TessLevelInner[0] = level;
    //    gl_TessLevelInner[1] = level;
    //}
}
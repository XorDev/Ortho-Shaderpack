#version 120

#define Scale 64. //Number of blocks that can be seen vertically. [4. 8. 16. 32. 64. 128. 256. 512]
#define Min 8. //Visible range. [0. 4. 8. 16. 32. 64. 128. 256. 512]
#define Max 128. //Visible range. [0. 4. 8. 16. 32. 64. 128. 256. 512]

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform float viewWidth;
uniform float viewHeight;

varying vec4 color;

void main()
{
    vec3 pos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    pos = (gbufferModelViewInverse * vec4(pos,1)).xyz;

    float s = Scale/2.;
    gl_Position = gbufferModelView * vec4(pos,1) / vec4(viewWidth/viewHeight*s,s,Min+Max,1)-vec4(0,0,Min/(Max+Min),0);
    gl_FogFragCoord = length(pos);

    color = gl_Color;
}

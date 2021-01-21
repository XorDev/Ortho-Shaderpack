#version 120

#define Scale 64. //Number of blocks that can be seen vertically. [4. 8. 16. 32. 64. 128. 256. 512]
#define Min 8. //Visible range. [0. 4. 8. 16. 32. 64. 128. 256. 512]
#define Max 128. //Visible range. [0. 4. 8. 16. 32. 64. 128. 256. 512]

attribute float mc_Entity;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform float viewWidth;
uniform float viewHeight;

varying vec4 color;
varying vec2 coord0;
varying vec2 coord1;

void main()
{
    vec3 pos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    pos = (gbufferModelViewInverse * vec4(pos,1)).xyz;

    float s = Scale/2.;
    gl_Position = gbufferModelView * vec4(pos,1) / vec4(viewWidth/viewHeight*s,s,-Min-Max,1)-vec4(0,0,(Max-Min)/(Max+Min),0);
    gl_FogFragCoord = length(pos);

    vec3 normal = gl_NormalMatrix * gl_Normal;
    normal = (mc_Entity==1.) ? vec3(0,1,0) : (gbufferModelViewInverse * vec4(normal,0)).xyz;

    float light = .8-.25*abs(normal.x*.9+normal.z*.3)+normal.y*.2;

    color = vec4(gl_Color.rgb*light, gl_Color.a);
    coord0 = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    coord1 = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
}

#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D DataSampler;

uniform float Time;
uniform vec2 OutSize;

in vec2 texCoord;

out vec4 fragColor;


// https://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl
float rand(vec2 co){
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt= dot(co.xy ,vec2(a,b));
    highp float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
}

void main(){

    fragColor = vec4(
        vec3(rand(ivec2(gl_FragCoord.xy/4) + Time)),
        1
    );
}
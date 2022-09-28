#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D DiffuseDepthSampler;

uniform mat4 ProjMat;
uniform vec2 InSize;
uniform vec2 OutSize;
uniform vec2 ScreenSize;

in vec2 texCoord;

out vec4 fragColor;

float far = 0.1; 
float near  = 1000.0;
float LinearizeDepth(float depth) 
{
    float z = depth * 2.0 - 1.0;
    return (near + far - z * (near - far)) / (far * near);    
}
 
void main(){

    float distanceFromCenter = distance(vec2(texCoord.x, texCoord.y) * ScreenSize, vec2(0.5, 0.5) * ScreenSize) / ScreenSize.x;
    float depth = LinearizeDepth(texture(DiffuseDepthSampler, texCoord).r);    
    vec4 originalPixel = texture(DiffuseSampler, texCoord);
    
    // Flashlight effect
    fragColor = vec4(originalPixel.rgb *
    (depth * 6) * // Dim when farther away from player
    (1 - (distanceFromCenter * 4)), // Dim when closer to edge of screen
    originalPixel.a);

    // Flashlight rings
    if(distanceFromCenter >= 0.1 && distanceFromCenter < 0.17){
        fragColor = vec4(fragColor.rgb * (1 + min(distanceFromCenter - 0.1, 0.17 - distanceFromCenter) * 8), fragColor.a);
    } else if (distanceFromCenter < 0.07){
        fragColor = vec4(fragColor.rgb * (1 + (0.07 - distanceFromCenter) * 8), fragColor.a);
    }
}

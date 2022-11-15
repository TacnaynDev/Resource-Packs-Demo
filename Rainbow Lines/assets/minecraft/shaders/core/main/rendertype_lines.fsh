#version 150

#moj_import <fog.glsl>
#moj_import <color_util.glsl>
#moj_import <config.glsl>

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform float GameTime;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec3 pos;

out vec4 fragColor;

void main() {
    
    vec4 color = vertexColor;

    // Target block outlines only
    if(vertexColor.rgb == vec3(0)){
        
        #if COLOR_MOTION_MODE == 0

        // Move colors away from player over time
        color = vec4(hsvToRGB((GameTime * COLOR_SHIFT_SPEED) - (length(pos) * COLOR_WAVE_LENGTH), SATURATION, VALUE), 1);
        
        #elif COLOR_MOTION_MODE == 1

        // Move colors toward player over time
        color = vec4(hsvToRGB((GameTime * COLOR_SHIFT_SPEED) + (length(pos) * COLOR_WAVE_LENGTH), SATURATION, VALUE), 1);

        #elif COLOR_MOTION_MODE == 2

        // Keep colors still
        color = vec4(hsvToRGB((GameTime * COLOR_SHIFT_SPEED) + ((pos.x + pos.y + pos.z) * COLOR_WAVE_LENGTH), SATURATION, VALUE), 1);

        #endif
        
    }
    
    color = color * ColorModulator;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}

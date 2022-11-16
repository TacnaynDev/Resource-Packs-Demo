#version 150

#moj_import <color_util.glsl>
#moj_import <config_rainbow_tooltips.glsl>

in vec4 vertexColor;
in vec3 pos;
flat in int isTooltip;

uniform vec4 ColorModulator;
uniform float GameTime;

out vec4 fragColor;

void main() {
    vec4 color = vertexColor;
    if (color.a == 0.0) {
        discard;
    }

    if(isTooltip == 1) {
        vec2 originPoint = pos.xy - vec2(ORIGIN_X, ORIGIN_Y);
        color = vec4(hsvToRGB((GameTime * ANIMATION_SPEED) + ((length(originPoint)) * WAVE_LENGTH), 1, color.b * BRIGHTNESS), color.a);
    }

    fragColor = color * ColorModulator;
}

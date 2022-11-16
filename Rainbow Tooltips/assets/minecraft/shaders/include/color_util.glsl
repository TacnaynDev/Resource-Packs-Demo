/*
 * Written by TacNayn (https://github.com/TacNaynDev)
 * Utility functions for modifying colors in Vanilla Minecraft Shaders
 */

// Takes a double between 0.0 and 1.0 and returns a color in RGB
// Translated From: https://stackoverflow.com/questions/61277046/convert-just-a-hue-into-rgb
vec3 hueToRGB(float hue) {

    hue *= 6; // Make numbers cleaner
    vec3 colors = mod(vec3(hue+5, hue+3, hue+1), 6); // Offset colors

    return 1 - clamp(min(colors, 4 - colors), 0, 1); // Make color value go up, then down, and clamp between 0 and 1
}

// Translates a color from HSV to RGB
vec3 hsvToRGB(float hue, float saturation, float value) {

    hue *= 6; // Make numbers cleaner
    vec3 colors = mod(vec3(hue+5, hue+3, hue+1), 6); // Offset colors

    return (1 - (clamp(min(colors, 4 - colors), 0, 1)) * saturation) * value;
}
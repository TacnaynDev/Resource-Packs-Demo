#version 150

#moj_import <vsh_util.glsl>

in vec3 Position;
in vec4 Color;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat3 IViewRotMat;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec4 ColorModulator;

out float vertexDistance;
flat out vec4 vertexColor;

void main() {

    // Grab model view matrix from inverse
    mat3 MVM = inverse(IViewRotMat);

    // Grab yaw from model view matrix
    mat4 rotationMat = mat4(
        MVM[0][0], 0, -MVM[2][0], 0, 
        0,         1, 0,          0,
        MVM[2][0], 0, MVM[0][0],  0,
        0,         0, 0,          1
    );

    vec3 newPos = Position.xzy * vec3(1, -1, 1); // Force top-down view with x, -z, y vector
    vec4 worldPos = mat4(IViewRotMat) * vec4(newPos, 1.0); // Convert to world coordinates

    worldPos = rotationMat * worldPos; // Apply rotation

    // Project world to screen
    mat4 OrthoMat = getOrthoMat(ProjMat, 0.0025);
    gl_Position = OrthoMat * worldPos;

    vertexDistance = length(worldPos);
    vertexColor = Color * ColorModulator * texelFetch(Sampler2, UV2 / 16, 0);
}

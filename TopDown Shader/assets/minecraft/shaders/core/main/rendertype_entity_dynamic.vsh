#version 150

#moj_import <vsh_util.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat3 IViewRotMat;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

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

    // Populate outputs
    normal = OrthoMat * vec4(Normal, 0.0);
    
    vertexDistance = length(worldPos);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    normal = OrthoMat * vec4(Normal, 0.0);
}

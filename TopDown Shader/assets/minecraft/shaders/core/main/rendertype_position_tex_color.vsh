#version 150

#moj_import <vsh_util.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform mat3 IViewRotMat;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 texCoord0;
out vec4 vertexColor;

void main() {

    if(isGUI(ProjMat) || isPanorama(ProjMat)){
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    } else {
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
        gl_Position = ProjMat * worldPos;
    }

    texCoord0 = UV0;
    vertexColor = Color;
}

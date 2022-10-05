#version 150

#moj_import <vsh_util.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;

uniform mat3 IViewRotMat;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat4 TextureMat;

uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    
    if(isGUI(ProjMat)){
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
        vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);

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
        mat4 OrthoMat = getOrthoMat(ProjMat, 0.0025);
        gl_Position = OrthoMat * worldPos;

        // Populate outpus
        vertexDistance = length(worldPos);
    }

    vertexColor = Color;
    texCoord0 = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;
}

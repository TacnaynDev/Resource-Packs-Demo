#version 150

#moj_import <light.glsl>
#moj_import <vsh_util.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec4 normal;

void main() {

    if(isGUI(ProjMat)){
        
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
        normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
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

        // Populate outputs
        normal = OrthoMat * vec4(Normal, 0.0);
        vertexDistance = length(worldPos);
    }

    // Populate outputs
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    overlayColor = texelFetch(Sampler1, UV1, 0);
    texCoord0 = UV0;
}

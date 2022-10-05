#version 150

#moj_import <light.glsl>
#moj_import <vsh_util.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

void main() {
    vec3 pos = Position + ChunkOffset;

    // Only rotate horizontally
    mat3 rotationMat = mat3(
        ModelViewMat[0][0], 0, -ModelViewMat[2][0], 
        0,                  1, 0, 
        ModelViewMat[2][0], 0, ModelViewMat[0][0]
    );

    vec3 viewPos = rotationMat * pos; // Apply rotation
    viewPos = viewPos.xzy * vec3(1, -1, 1); // Force top-down view with x, -z, y vector

    // Project world to screen
    mat4 OrthoMat = getOrthoMat(ProjMat, 0.0025);
    gl_Position = OrthoMat * vec4(viewPos, 1.0);

    // Populate outputs
    normal = OrthoMat * vec4(Normal, 0.0);
    vertexDistance = length(viewPos);
    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
}

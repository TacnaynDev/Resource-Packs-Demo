#version 150

#moj_import <vsh_util.glsl>

in vec3 Position;
in vec4 Color;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform float LineWidth;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;

const float VIEW_SHRINK = 1.0 - (1.0 / 256.0);
const mat4 VIEW_SCALE = mat4(
    VIEW_SHRINK, 0.0, 0.0, 0.0,
    0.0, VIEW_SHRINK, 0.0, 0.0,
    0.0, 0.0, VIEW_SHRINK, 0.0,
    0.0, 0.0, 0.0, 1.0
);

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

    // Get Orthographic Projection Matrix
    mat4 OrthoMat = getOrthoMat(ProjMat, 0.0025);

    // Vanilla code
    vec4 linePosStart = OrthoMat * VIEW_SCALE * worldPos;
    vec4 linePosEnd = OrthoMat * VIEW_SCALE * vec4(worldPos.xyz + Normal, 1.0);

    vec3 ndc1 = linePosStart.xyz / linePosStart.w;
    vec3 ndc2 = linePosEnd.xyz / linePosEnd.w;

    vec2 lineScreenDirection = normalize((ndc2.xy - ndc1.xy) * ScreenSize);
    vec2 lineOffset = vec2(-lineScreenDirection.y, lineScreenDirection.x) * LineWidth / ScreenSize;

    if (lineOffset.x < 0.0) {
        lineOffset *= -1.0;
    }

    if (gl_VertexID % 2 == 0) {
        gl_Position = vec4((ndc1 + vec3(lineOffset, 0.0)) * linePosStart.w, linePosStart.w);
    } else {
        gl_Position = vec4((ndc1 - vec3(lineOffset, 0.0)) * linePosStart.w, linePosStart.w);
    }

    vertexDistance = length(worldPos);
    vertexColor = Color;
}

#version 150

#moj_import <vsh_util.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV2;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec2 texCoord2;
out vec4 normal;

void main() {

    // Skip GUI
    if (!isGUI(ProjMat)) {
        gl_Position = vec4(0);
    } else {
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
        normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
    }
    
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = Color;
    texCoord0 = UV0;
    texCoord2 = UV2;
}

// Bottom half of sky, sun & moon, and various GUI elements

#version 150

#moj_import <vsh_util.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat3 IViewRotMat;
uniform mat4 ProjMat;
uniform float GameTime;

out vec4 vertexColor;
out vec2 texCoord0;
out vec3 pos;
flat out int isTooltip;

void main() {

    texCoord0 = UV0;
    vertexColor = Color;
    pos = Position;
    isTooltip = 0;

    // GUI
    if (!isGUI(ProjMat)) {
        
        // Use default rendering for sky
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

        return;
    }
    
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    
    // Only item tooltips have a z of 400
    if(Position.z == 400) {
        isTooltip = 1;
        vertexColor = Color.bbba;
    }
}

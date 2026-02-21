//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to render momentary and toggle buttons
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

int state;
int toggleState;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components
    
    gui.button("Basic", @(0, 0.5)) => state;
    gui.toggleButton("Toggle", @(0, -0.5), toggleState) => toggleState;

    if (state == 1) {
        <<< "Button clicked" >>>;
    }

    <<< "Toggle:", toggleState >>>;
}
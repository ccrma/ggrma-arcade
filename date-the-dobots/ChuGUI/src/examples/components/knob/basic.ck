//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to render a knob
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

float val;

while (true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.knob("Knob", @(0, 0), 0, 1, val) => val;

    <<< "Value:", val >>>;
}

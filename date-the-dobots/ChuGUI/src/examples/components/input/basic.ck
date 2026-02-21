//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to render an input field
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

string input;

while (true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.input("Input", @(0, 0), input, "Input...") => input;
}

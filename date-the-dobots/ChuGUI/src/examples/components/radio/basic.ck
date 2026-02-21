//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to render a radio
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

["Red", "Green", "Blue"] @=> string colors[];
0 => int colorIx;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.label("Choose a color:", @(0, 0.6));
    gui.radio("colorRadio", @(0, 0.4), colors, colorIx) => colorIx;
    gui.label("Selected: " + colors[colorIx], @(0, 0));
}
//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to render spinners
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

5 => int num;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.spinner("Basic", @(0, 0), 0, 10, num) => num;

    <<< "Num:", num >>>;
}
//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to render checkboxes
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

0 => int checked;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.checkbox("Basic", @(0, 0), checked) => checked;

    <<< "Checked:", checked >>>;
}
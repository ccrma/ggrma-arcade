//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to render a dropdown
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

["Option 1", "Option 2", "Option 3"] @=> string options[];
-1 => int selected;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.dropdown("Dropdown", @(0, 0), options, selected) => selected;

    if (selected == -1) {
        <<< "Selected: None" >>>;
    } else {
        <<< "Selected:", options[selected] >>>;
    }
}
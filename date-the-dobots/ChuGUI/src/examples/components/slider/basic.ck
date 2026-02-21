//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to render continuous and discrete sliders
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

0.2 => float value1;
0.5 => float value2;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.slider("slider1", @(0, 0.7), 0, 1, value1) => value1;
    gui.label("Value: " + value1, @(0, 0.5));
    
    gui.discreteSlider("slider3", @(0, -0.7), 1, 5, 9, value2) => value2;
    gui.label("Value: " + value2, @(0, -0.9));
}

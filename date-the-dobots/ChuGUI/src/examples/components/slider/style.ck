//-----------------------------------------------------------------------------
// name: style.ck
// desc: this example shows how to render and style continuous and discrete sliders
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
2 => float value3;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.slider("slider1", @(0, 0.7), 0, 1, value1) => value1;
    gui.label("Value: " + value1, @(0, 0.5));
    
    // Blue
    UIStyle.pushColor(UIStyle.COL_SLIDER_TRACK, @(0.1, 0.4, 1.0));
    UIStyle.pushVar(UIStyle.VAR_SLIDER_TRACK_BORDER_RADIUS, 0.4);
    UIStyle.pushVar(UIStyle.VAR_SLIDER_HANDLE_BORDER_RADIUS, 0.4);
    UIStyle.pushVar(UIStyle.VAR_SLIDER_TRACK_BORDER_WIDTH, 0.2);
    gui.slider("slider2", @(0, -0.0), 0, 1, value2) => value2;
    gui.label("Value: " + value2, @(0, -0.2));
    UIStyle.popColor();
    UIStyle.popVar(3);

    // Discrete, Green handle
    UIStyle.pushColor(UIStyle.COL_SLIDER_HANDLE, @(0.1, 0.8, 0.2));
    gui.discreteSlider("slider3", @(0, -0.7), 0, 5, 5, value3) => value3;
    gui.label("Value: " + value3, @(0, -0.9));
    UIStyle.popColor();

    UIStyle.pushVar(UIStyle.VAR_SLIDER_ROTATE, Math.PI / 2);
    gui.slider("vertical", @(-0.75, 0), 0, 1, value1) => value1;
    gui.discreteSlider("discreteVertical", @(0.75, 0), 0, 5, 5, value3) => value3;
    UIStyle.popVar();
}

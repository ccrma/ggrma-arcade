//-----------------------------------------------------------------------------
// name: style.ck
// desc: this example shows how to render and style knobs
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

0.1 => float val1;
0.7 => float val2;
0.4 => float val3;
1.0 => float val4;
0.3 => float val5;
0.5 => float val6;

while (true) {
    GG.nextFrame() => now; // must be called before rendering any components

    UIStyle.pushVar(UIStyle.VAR_KNOB_CONTROL_POINTS, @(0, 0.5));

    UIStyle.pushColor(UIStyle.COL_KNOB, @(0.30,0.93,0.93));
    UIStyle.pushColor(UIStyle.COL_KNOB_BORDER, @(0.05,0.41,0.44));
    UIStyle.pushColor(UIStyle.COL_KNOB_INDICATOR, @(0.15,0.15,0.5));
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_RADIUS, 1.0);
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_WIDTH, 0.10);
    UIStyle.pushVar(UIStyle.VAR_KNOB_SIZE, @(0.5, 0.5));
    gui.knob("AquaKnob", @(-0.85, 0.6), 0, 1, val1) => val1;
    UIStyle.popVar(3);
    UIStyle.popColor(3);

    UIStyle.pushColor(UIStyle.COL_KNOB, @(0.20,0.23,0.29));
    UIStyle.pushColor(UIStyle.COL_KNOB_BORDER, @(0.70,0.45,0.10));
    UIStyle.pushColor(UIStyle.COL_KNOB_INDICATOR, @(1.0,0.54,0.1));
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_RADIUS, 0.32);
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_WIDTH, 0.07);
    UIStyle.pushVar(UIStyle.VAR_KNOB_SIZE, @(0.45, 0.45));
    gui.knob("DarkKnob", @(-0.85, 0.25), 0, 1, val2) => val2;
    UIStyle.popVar(3);
    UIStyle.popColor(3);

    UIStyle.pushColor(UIStyle.COL_KNOB, @(1.0,0.97,0.98));
    UIStyle.pushColor(UIStyle.COL_KNOB_BORDER, @(0.99,0.14,0.56));
    UIStyle.pushColor(UIStyle.COL_KNOB_INDICATOR, @(0.24,1.0,0.33));
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_RADIUS, 0.0);
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_WIDTH, 0.15);
    UIStyle.pushVar(UIStyle.VAR_KNOB_SIZE, @(0.5, 0.5));
    gui.knob("PinkKnob", @(-0.85, -0.1), 0, 1, val3) => val3;
    UIStyle.popVar(3);
    UIStyle.popColor(3);

    UIStyle.pushColor(UIStyle.COL_KNOB, @(0.51,0.66,0.98));
    UIStyle.pushColor(UIStyle.COL_KNOB_BORDER, @(0.00,0.16,0.61));
    UIStyle.pushColor(UIStyle.COL_KNOB_INDICATOR, @(1,0.48,0.00));
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_RADIUS, 1.00);
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_WIDTH, 0.10);
    UIStyle.pushVar(UIStyle.VAR_KNOB_SIZE, @(0.55, 0.55));
    gui.knob("BlueKnob", @(0.25, 0.6), 0, 1, val4) => val4;
    UIStyle.popVar(2);
    UIStyle.popColor(3);

    UIStyle.pushColor(UIStyle.COL_KNOB, @(1,1,0.7));
    UIStyle.pushColor(UIStyle.COL_KNOB_BORDER, @(1,0.91,0.19));
    UIStyle.pushColor(UIStyle.COL_KNOB_INDICATOR, @(0.51,0.15,0.98));
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_RADIUS, 0.4);
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_WIDTH, 0.22);
    UIStyle.pushVar(UIStyle.VAR_KNOB_SIZE, @(0.5, 0.5));
    gui.knob("YellowKnob", @(0.25, 0.25), 0, 1, val5) => val5;
    UIStyle.popVar(3);
    UIStyle.popColor(3);

    UIStyle.pushColor(UIStyle.COL_KNOB, @(0.90,0.91,0.91));
    UIStyle.pushColor(UIStyle.COL_KNOB_BORDER, @(0.70,0.70,0.70));
    UIStyle.pushColor(UIStyle.COL_KNOB_INDICATOR, @(1,0.18,0.07));
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_RADIUS, 0.18);
    UIStyle.pushVar(UIStyle.VAR_KNOB_BORDER_WIDTH, 0.04);
    UIStyle.pushVar(UIStyle.VAR_KNOB_SIZE, @(0.45, 0.45));
    gui.knob("LightKnob", @(0.25, -0.1), 0, 1, val6) => val6;
    UIStyle.popVar(3);
    UIStyle.popColor(3);

    UIStyle.popVar();
}

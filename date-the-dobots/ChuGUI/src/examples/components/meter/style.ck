//-----------------------------------------------------------------------------
// name: style.ck
// desc: this example shows how to render and style meters
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

2.5 => float staticValue;
2.5 => float dynamicValue;
2.5 => float verticalValue;
3.0 => float thinValue;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    now / second => float time;

    // Animate dynamic meters with sine waves
    (Math.sin(time * 1.5) * 0.5 + 0.5) * 5 => dynamicValue;  // 0..5 oscillation
    (Math.cos(time * 2.0) * 0.5 + 0.5) * 5 => verticalValue;
    (Math.cos(time) * 0.5 + 0.5) * 5 => thinValue;

    // Static Horizontal Meter
    UIStyle.pushVar(UIStyle.VAR_METER_CONTROL_POINTS, @(0, 0.5));

    UIStyle.pushVar(UIStyle.VAR_METER_SIZE, @(4, 0.35));
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_RADIUS, 0.2);
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_WIDTH, 0.08);
    gui.meter(@(-0.95, 0.5), 0, 5, staticValue);
    UIStyle.popVar(3);

    // Dynamic Horizontal Meter with default colors
    UIStyle.pushVar(UIStyle.VAR_METER_SIZE, @(4, 0.35));
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_RADIUS, 0.15);
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_WIDTH, 0.05);
    gui.meter(@(-0.95, 0.25), 0, 5, dynamicValue);
    UIStyle.popVar(3);

    // Static Vertical Meter (rotated 90 degrees)
    UIStyle.pushVar(UIStyle.VAR_METER_SIZE, @(0.35, 2));
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_RADIUS, 0.25);
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_WIDTH, 0.1);
    UIStyle.pushVar(UIStyle.VAR_METER_ROTATE, Math.PI / 2);
    gui.meter(@(0.25, 0.5), 0, 5, staticValue);
    UIStyle.popVar(4);

    // Dynamic Vertical Meter (rotated 90 degrees) with custom colors
    UIStyle.pushVar(UIStyle.VAR_METER_SIZE, @(2, 0.2));
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_RADIUS, 0.25);
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_WIDTH, 0.1);
    UIStyle.pushColor(UIStyle.COL_METER_FILL, @(0.85, 0.25, 0.25, 1)); // Red fill
    UIStyle.pushColor(UIStyle.COL_METER_TRACK, @(0.9, 0.9, 0.9, 1));   // Light track
    UIStyle.pushVar(UIStyle.VAR_METER_ROTATE, Math.PI / 2);
    gui.meter(@(0, 0), 0, 5, verticalValue);
    UIStyle.popColor(2);
    UIStyle.popVar(4);

    // Thin Dynamic Horizontal Meter (small height)
    UIStyle.pushVar(UIStyle.VAR_METER_SIZE, @(4, 0.1));
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_RADIUS, 0.05);
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_WIDTH, 0.02);
    UIStyle.pushColor(UIStyle.COL_METER_FILL, @(0.3, 0.6, 0.9, 1));  // Blue fill
    UIStyle.pushColor(UIStyle.COL_METER_TRACK, @(0.8, 0.8, 0.8, 1));  // Light track
    gui.meter(@(-0.95, 0), 0, 5, thinValue);
    UIStyle.popColor(2);
    UIStyle.popVar(3);

    // Wide Custom Meter with thick border and rounded corners
    UIStyle.pushVar(UIStyle.VAR_METER_SIZE, @(4, 0.5));
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_RADIUS, 0.3);
    UIStyle.pushVar(UIStyle.VAR_METER_BORDER_WIDTH, 0.15);
    UIStyle.pushColor(UIStyle.COL_METER_FILL, @(0.1, 0.5, 0.1, 1));  // Dark green fill
    UIStyle.pushColor(UIStyle.COL_METER_TRACK, @(0.9, 0.95, 0.9, 1)); // Very light track
    gui.meter(@(-0.95, -0.25), 0, 5, dynamicValue);
    UIStyle.popColor(2);
    UIStyle.popVar(4);

    UIStyle.popVar();
}

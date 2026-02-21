//-----------------------------------------------------------------------------
// name: style.ck
// desc: this example shows how to render and style input fields
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

"" => string input1;
"" => string input2;
"" => string input3;
"" => string input4;
"" => string input5;
"" => string input6;
"" => string input7;
"" => string input8;

while (true) {
    GG.nextFrame() => now; // must be called before rendering any components

    UIStyle.pushVar(UIStyle.VAR_INPUT_CONTROL_POINTS, @(0, 0.5));

    UIStyle.pushColor(UIStyle.COL_INPUT_BORDER, @(0.15,0.35,0.95));
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_RADIUS, 0.45);
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_WIDTH, 0.17);
    gui.input("Blue Rounded", @(-0.95, 0.62), input1, "Blue & round") => input1;
    UIStyle.popVar(2);
    UIStyle.popColor();

    UIStyle.pushColor(UIStyle.COL_INPUT_BORDER, @(0.2,0.90,0.3));
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_RADIUS, 0.10);
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_WIDTH, 0.25);
    gui.input("Wide Green", @(-0.95, 0.36), input2, "Wide border") => input2;
    UIStyle.popVar(2);
    UIStyle.popColor();

    UIStyle.pushColor(UIStyle.COL_INPUT, @(0.98,0.8,0.9));
    UIStyle.pushColor(UIStyle.COL_INPUT_BORDER, @(0.86,0.11,0.69));
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_RADIUS, 0.0);
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_WIDTH, 0.11);
    gui.input("Pink Square", @(-0.95, 0.10), input3, "Type pink!") => input3;
    UIStyle.popVar(2);
    UIStyle.popColor(2);

    UIStyle.pushColor(UIStyle.COL_INPUT_BORDER, @(1.0,0.5,0.1));
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_RADIUS, 0.18);
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_WIDTH, 0.13);
    gui.input("Orange Style", @(-0.95, -0.16), input4, "Orange!") => input4;
    UIStyle.popVar(2);
    UIStyle.popColor();

    UIStyle.pushColor(UIStyle.COL_INPUT_BORDER, @(0.95,0.25,0.15));
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_RADIUS, 1.0);
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_WIDTH, 0.18);
    UIStyle.pushVar(UIStyle.VAR_INPUT_TEXT_SIZE, 0.28);
    gui.input("Big Red", @(0.2, 0.62), input5, "LARGE") => input5;
    UIStyle.popVar(2);
    UIStyle.popColor();

    UIStyle.pushColor(UIStyle.COL_INPUT_BORDER, @(0.6,0.3,1.0));
    UIStyle.pushColor(UIStyle.COL_INPUT, @(0.95,0.95,1.0));
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_RADIUS, 0.22);
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_WIDTH, 0.14);
    gui.input("Violet Fill", @(0.2, 0.36), input6, "Violet") => input6;
    UIStyle.popVar(2);
    UIStyle.popColor(2);

    UIStyle.pushColor(UIStyle.COL_INPUT_BORDER, @(0,0,0));
    UIStyle.pushColor(UIStyle.COL_INPUT, @(1,1,0.75));
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_RADIUS, 0.0);
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_WIDTH, 0.19);
    gui.input("Yellow Square", @(0.2, 0.10), input7, "YELLOW") => input7;
    UIStyle.popVar(2);
    UIStyle.popColor(2);

    UIStyle.pushColor(UIStyle.COL_INPUT_BORDER, @(0.15,0.35,0.95));
    UIStyle.pushColor(UIStyle.COL_INPUT, @(0.92,0.96,1.0));
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_RADIUS, 0.36);
    UIStyle.pushVar(UIStyle.VAR_INPUT_BORDER_WIDTH, 0.12);
    gui.input("Disabled", @(0.2, -0.16), "", "Disabled!", true);
    UIStyle.popVar(2);
    UIStyle.popColor(2);

    UIStyle.popVar();
}

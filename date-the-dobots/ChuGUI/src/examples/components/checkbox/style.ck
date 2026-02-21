//-----------------------------------------------------------------------------
// name: style.ck
// desc: this example shows how to render and style checkboxes
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().light().intensity(0.0);
GG.scene().ambient(Color.WHITE);
GG.scene().backgroundColor(Color.BLACK);

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

0 => int checked0;
0 => int checked1;
1 => int checked2;
0 => int checked3;
0 => int checked4;
0 => int checked5;
1 => int checked6;
0 => int checked7;
1 => int checked8;
0 => int checked9;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    0.5 => float baseY;
    0.2 => float spacingY;
    -0.8 => float xLeft;
    0.2 => float xRight;
    
    // --- Row 0: Default basic checkbox ---
    UIStyle.pushColor(UIStyle.COL_CHECKBOX, Color.WHITE);
    UIStyle.pushColor(UIStyle.COL_CHECKBOX_BORDER, @(0.2, 0.2, 0.2));
    UIStyle.pushVar(UIStyle.VAR_CHECKBOX_BORDER_RADIUS, 0.15);
    gui.checkbox("Basic White", @(xLeft, baseY), checked0) => checked0;
    UIStyle.popColor(2);
    UIStyle.popVar();

    // --- Row 1: Larger checkbox with red border and rounded ---
    UIStyle.pushColor(UIStyle.COL_CHECKBOX_BORDER, Color.RED);
    UIStyle.pushVar(UIStyle.VAR_CHECKBOX_SIZE, @(0.35, 0.35));
    UIStyle.pushVar(UIStyle.VAR_CHECKBOX_BORDER_RADIUS, 0.5);
    gui.checkbox("Large Red Rounded", @(xLeft, baseY - spacingY), checked1) => checked1;
    UIStyle.popVar(2);
    UIStyle.popColor();

    // --- Row 2: Disabled, checked checkbox ---
    UIStyle.pushColor(UIStyle.COL_CHECKBOX_ICON, Color.BLACK);
    gui.checkbox("Disabled Checked", @(xLeft, baseY - spacingY * 2), 0, true);
    UIStyle.popColor();

    // --- Row 3: Custom icon 'star' with yellow color when checked ---
    UIStyle.pushVar(UIStyle.VAR_CHECKBOX_ICON, "star");
    UIStyle.pushColor(UIStyle.COL_CHECKBOX_ICON, Color.BLACK);
    UIStyle.pushColor(UIStyle.COL_CHECKBOX_PRESSED, @(1, 1, 0, 1)); // yellow
    gui.checkbox("Star Icon Yellow", @(xLeft, baseY - spacingY * 3), checked2) => checked2;
    UIStyle.popColor(2);
    UIStyle.popVar();

    // --- Row 4: Square checkbox with no border radius ---
    UIStyle.pushVar(UIStyle.VAR_CHECKBOX_BORDER_RADIUS, 0.0);
    gui.checkbox("Square Style", @(xLeft, baseY - spacingY * 4), checked3) => checked3;
    UIStyle.popVar();

    // --- Row 5: Small checkbox rotated +15 degrees ---
    UIStyle.pushVar(UIStyle.VAR_CHECKBOX_SIZE, @(0.15, 0.15));
    UIStyle.pushVar(UIStyle.VAR_CHECKBOX_ROTATE, 0.26); // ~15 degrees in radians
    gui.checkbox("Small Rotated", @(xLeft, baseY - spacingY * 5), checked4) => checked4;
    UIStyle.popVar(2);

    // --- Row 6: Disabled with custom icon 'heart' and disabled icon color ---
    UIStyle.pushVar(UIStyle.VAR_CHECKBOX_ICON, "heart");
    UIStyle.pushColor(UIStyle.COL_CHECKBOX_ICON, Color.BLACK);
    gui.checkbox("Disabled Heart Icon", @(xLeft, baseY - spacingY * 6), checked5, true);
    UIStyle.popVar();
    UIStyle.popColor();

    // // -- Right side variations --

    // --- Row 0: Green background checkbox ---
    UIStyle.pushColor(UIStyle.COL_CHECKBOX, @(0, 0.6, 0, 1));
    UIStyle.pushColor(UIStyle.COL_CHECKBOX_BORDER, Color.DARKGREEN);
    gui.checkbox("Green Box", @(xRight, baseY), checked6) => checked6;
    UIStyle.popColor(2);

    // --- Row 1: Huge checkbox with thick border ---
    UIStyle.pushVar(UIStyle.VAR_CHECKBOX_SIZE, @(0.5, 0.5));
    UIStyle.pushVar(UIStyle.VAR_CHECKBOX_BORDER_WIDTH, 0.2);
    gui.checkbox("Huge Thick Border", @(xRight, baseY - spacingY), checked7) => checked7;
    UIStyle.popVar(2);

    // --- Row 2: Disabled, unchecked with blue border ---
    UIStyle.pushColor(UIStyle.COL_CHECKBOX_BORDER, Color.BLUE);
    gui.checkbox("Disabled Blue Border", @(xRight, baseY - spacingY * 2), 0, true);
    UIStyle.popColor();

    // --- Row 3: Icon 'check' scaled large ---
    UIStyle.pushVar(UIStyle.VAR_CHECKBOX_ICON_SIZE, 0.8);
    gui.checkbox("Large Check Icon", @(xRight, baseY - spacingY * 3), checked8) => checked8;
    UIStyle.popVar();

    // --- Row 4: Minimalist, transparent background checkbox ---
    UIStyle.pushColor(UIStyle.COL_CHECKBOX, @(0, 0, 0, 0));
    UIStyle.pushColor(UIStyle.COL_CHECKBOX_BORDER, @(0.5, 0.5, 0.5, 0.5));
    gui.checkbox("Transparent Box", @(xRight, baseY - spacingY * 4), checked9) => checked9;
    UIStyle.popColor(2);
}
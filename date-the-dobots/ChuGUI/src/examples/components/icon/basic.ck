//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to render and style icons
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

me.dir() + "icons/" => string iconDir;

while (true) {
    GG.nextFrame() => now; // must be called before rendering any components

    UIStyle.pushColor(UIStyle.COL_ICON, Color.WHITE);

    // Default
    gui.icon(iconDir + "acorn.png", @(-0.75, 0.5));

    // Large icon
    UIStyle.pushVar(UIStyle.VAR_ICON_SIZE, @(0.5, 0.5));
    gui.icon(iconDir + "cookie.png", @(0, 0.5));
    UIStyle.popVar();

    // Small red icon
    UIStyle.pushColor(UIStyle.COL_ICON, Color.RED);
    UIStyle.pushVar(UIStyle.VAR_ICON_SIZE, @(0.2, 0.2));
    gui.icon(iconDir + "star.png", @(0.75, 0.5));
    UIStyle.popVar();
    UIStyle.popColor();

    // Blue icon
    UIStyle.pushColor(UIStyle.COL_ICON, Color.BLUE);
    gui.icon(iconDir + "heart.png", @(-0.75, 0));
    UIStyle.popColor();

    // Green icon with rotation
    UIStyle.pushColor(UIStyle.COL_ICON, Color.GREEN);
    UIStyle.pushVar(UIStyle.VAR_ICON_ROTATE, 0.3); // radians (~17 degrees)
    gui.icon(iconDir + "bell.png", @(0, 0));
    UIStyle.popVar();
    UIStyle.popColor();

    // Yellow icon
    UIStyle.pushColor(UIStyle.COL_ICON, @(1, 1, 0, 0.5));
    gui.icon(iconDir + "smiley.png", @(0.75, 0));
    UIStyle.popColor();

    gui.icon(iconDir + "music-note.png", @(0, -0.5));

    gui.icon(iconDir + "chuck.png", @(-0.75, -0.5));

    gui.icon(ChuGUI.SEARCH, @(0.75, -0.5));

    UIStyle.popColor();
}

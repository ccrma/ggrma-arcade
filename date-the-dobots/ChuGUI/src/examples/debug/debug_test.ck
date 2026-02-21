// Debug Panel Test Example
// This example demonstrates the real-time style editing debug panel.

@import "../../ChuGUI.ck"

GG.camera().orthographic();

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

// Enable debug mode
gui.debugEnabled(true);

// State variables
0.5 => float sliderVal;
false => int checkboxVal;
0 => int dropdownVal;
["Option A", "Option B", "Option C"] @=> string options[];

while (true) {
    GG.nextFrame() => now;

    // Render components
    gui.button("My Button", @(-0.5, 0.7));
    gui.debugAdd();

    gui.slider("volume", @(-0.5, 0.5), 0.0, 1.0, sliderVal) => sliderVal;
    gui.debugAdd();

    gui.checkbox("mute", @(-0.5, 0.3), checkboxVal) => checkboxVal;
    gui.debugAdd();

    gui.dropdown("Select", @(-0.5, 0.1), options, dropdownVal) => dropdownVal;
    gui.debugAdd();

    gui.label("Hello World", @(-0.5, -0.1));
    gui.debugAdd();

    // Render the debug panel
    gui.debug();
}

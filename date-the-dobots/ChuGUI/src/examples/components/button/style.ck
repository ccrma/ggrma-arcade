//-----------------------------------------------------------------------------
// name: style.ck
// desc: this example shows how to render and style momentary and toggle buttons
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

0 => int toggle1;
0 => int toggle2;
0 => int toggle3;
0 => int toggle4;
0 => int toggle5;
0 => int toggle6;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    // Push global label styling
    UIStyle.pushColor(UIStyle.COL_LABEL, Color.WHITE);
            
    // Normal Buttons Section
    UIStyle.pushVar(UIStyle.VAR_LABEL_SIZE, 0.25);
    UIStyle.pushVar(UIStyle.VAR_LABEL_CONTROL_POINTS, @(0, 0.5));
    gui.label("Normal Buttons", @(-0.95, 0.7));
    
    // Set common button properties
    UIStyle.pushVar(UIStyle.VAR_BUTTON_CONTROL_POINTS, @(0, 0.5));
    UIStyle.pushVar(UIStyle.VAR_BUTTON_SIZE, ChuGUI.NDCToWorldSize(@(0.35, 0.12)));
    
    // Row 1: Basic buttons
    gui.button("Default", @(-0.95, 0.55));
    
    UIStyle.pushColor(UIStyle.COL_BUTTON, Color.GRAY);
    gui.button("Disabled", @(-0.55, 0.55), true) => int clicked;
    UIStyle.popColor();

    if (clicked) {
        <<< "Disabled button clicked!" >>>;
    }
    
    // Row 2: Buttons with icons
    gui.button("Add", ChuGUI.PLUS, @(-0.95, 0.4));
    
    UIStyle.pushVar(UIStyle.VAR_BUTTON_ICON_POSITION, UIStyle.RIGHT);
    gui.button("Subtract", ChuGUI.MINUS, @(-0.55, 0.4));
    UIStyle.popVar();
    
    // Row 3: Colored buttons
    UIStyle.pushColor(UIStyle.COL_BUTTON, Color.BLUE);
    UIStyle.pushColor(UIStyle.COL_BUTTON_TEXT, Color.WHITE);
    gui.button("Blue", @(-0.95, 0.25));
    UIStyle.popColor(2);
    
    UIStyle.pushColor(UIStyle.COL_BUTTON, Color.RED);
    UIStyle.pushColor(UIStyle.COL_BUTTON_TEXT, Color.WHITE);
    UIStyle.pushColor(UIStyle.COL_BUTTON_BORDER, Color.MAROON);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_BORDER_WIDTH, 0.15);
    gui.button("Red", @(-0.55, 0.25));
    UIStyle.popVar();
    UIStyle.popColor(3);
    
    // Row 4: Rounded buttons
    UIStyle.pushColor(UIStyle.COL_BUTTON, Color.GREEN);
    UIStyle.pushColor(UIStyle.COL_BUTTON_TEXT, Color.WHITE);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_BORDER_RADIUS, 0.5);
    gui.button("Green", @(-0.95, 0.1));
    UIStyle.popVar();
    UIStyle.popColor(2);
    
    UIStyle.pushColor(UIStyle.COL_BUTTON, Color.YELLOW);
    UIStyle.pushColor(UIStyle.COL_BUTTON_TEXT, Color.BLACK);
    UIStyle.pushColor(UIStyle.COL_BUTTON_BORDER, Color.ORANGE);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_BORDER_WIDTH, 0.1);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_BORDER_RADIUS, 1.0);
    gui.button("Round", @(-0.55, 0.1));
    UIStyle.popVar(2);
    UIStyle.popColor(3);
    
    // Row 5: Special styled buttons
    UIStyle.pushColor(UIStyle.COL_BUTTON, Color.PURPLE);
    UIStyle.pushColor(UIStyle.COL_BUTTON_TEXT, Color.WHITE);
    UIStyle.pushColor(UIStyle.COL_BUTTON_ICON, Color.YELLOW);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_ICON_SIZE, 0.3);
    gui.button("User", ChuGUI.USER, @(-0.95, -0.05));
    UIStyle.popVar();
    UIStyle.popColor(3);
    
    UIStyle.pushColor(UIStyle.COL_BUTTON, @(0.2, 0.8, 0.9, 1.0));
    UIStyle.pushColor(UIStyle.COL_BUTTON_TEXT, Color.BLACK);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_TEXT_SIZE, 0.15);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_SIZE, ChuGUI.NDCToWorldSize(@(0.25, 0.08)));
    gui.button("Small", @(-0.55, -0.05));
    UIStyle.popVar(2);
    UIStyle.popColor(2);
    
    // Toggle Buttons Section
    gui.label("Toggle Buttons", @(-0.95, -0.25));
            
    // Row 1: Basic toggles
    gui.toggleButton("Toggle 1", @(-0.95, -0.4), toggle1) => toggle1;
    gui.toggleButton("Disabled", @(-0.55, -0.4), toggle2, true) => toggle2;
    
    // Row 2: Icon toggles
    UIStyle.pushColor(UIStyle.COL_BUTTON, @(0.3, 0.3, 0.3));
    UIStyle.pushColor(UIStyle.COL_BUTTON_PRESSED, Color.ORANGE);
    UIStyle.pushColor(UIStyle.COL_BUTTON_ICON, Color.WHITE);
    UIStyle.pushColor(UIStyle.COL_BUTTON_ICON_PRESSED, Color.BLACK);
    gui.toggleButton("Search", ChuGUI.SEARCH, @(-0.95, -0.55), toggle3) => toggle3;
    UIStyle.popColor(4);
    
    UIStyle.pushColor(UIStyle.COL_BUTTON, @(0.2, 0.2, 0.2));
    UIStyle.pushColor(UIStyle.COL_BUTTON_PRESSED, Color.BLUE);
    UIStyle.pushColor(UIStyle.COL_BUTTON_TEXT, Color.GRAY);
    UIStyle.pushColor(UIStyle.COL_BUTTON_TEXT_PRESSED, Color.WHITE);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_ICON_POSITION, UIStyle.RIGHT);
    gui.toggleButton("Check", ChuGUI.CHECK, @(-0.55, -0.55), toggle4) => toggle4;
    UIStyle.popVar();
    UIStyle.popColor(4);
    
    // Row 3: Styled toggles
    UIStyle.pushColor(UIStyle.COL_BUTTON, Color.MAROON);
    UIStyle.pushColor(UIStyle.COL_BUTTON_PRESSED, Color.RED);
    UIStyle.pushColor(UIStyle.COL_BUTTON_TEXT, Color.WHITE);
    UIStyle.pushColor(UIStyle.COL_BUTTON_BORDER, Color.WHITE);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_BORDER_WIDTH, toggle5 ? 0.2 : 0.05);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_BORDER_RADIUS, 0.3);
    gui.toggleButton("Alert", @(-0.95, -0.7), toggle5) => toggle5;
    UIStyle.popVar(2);
    UIStyle.popColor(4);
    
    UIStyle.pushColor(UIStyle.COL_BUTTON, @(0.4, 0.4, 0.0));
    UIStyle.pushColor(UIStyle.COL_BUTTON_PRESSED, Color.YELLOW);
    UIStyle.pushColor(UIStyle.COL_BUTTON_TEXT, Color.BLACK);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_BORDER_RADIUS, 1.0);
    UIStyle.pushVar(UIStyle.VAR_BUTTON_SIZE, ChuGUI.NDCToWorldSize(@(0.3, 0.1)));
    gui.toggleButton("", ChuGUI.GEAR, @(-0.55, -0.7), toggle6) => toggle6;
    UIStyle.popVar(2);
    UIStyle.popColor(3);
    
    UIStyle.popVar(2); // Pop button common properties
    UIStyle.popColor(); // Pop global label color
}
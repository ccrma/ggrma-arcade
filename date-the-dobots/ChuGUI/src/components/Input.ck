@import "../lib/UIUtil.ck"
@import "../lib/MouseState.ck"
@import "../lib/GComponent.ck"
@import "../gmeshes/GRect.ck"
@import "../UIStyle.ck"

public class Input extends GComponent {
    GRect gField --> this;
    GText gText --> this;
    GRect gCursor --> this;

    string _value;
    string _placeholder;

    false => int _focused;
    
    0 => int _cursorPos;
    0.0 => float _cursorTimer;
    true => int _cursorVisible;

    new MouseState(this, gField) @=> _state;

    0 => static int frameCount;
    int lastKey[0];       // frame counter when key was first pressed
    20 => int repeatDelay;   // frames before repeating
    5 => int repeatRate;    // frames between repeats

    // ==== Getters and Setters ====

    fun string value() { return _value; }
    fun void value(string value) { 
        value => _value; 
        Math.clampi(_cursorPos, 0, _value.length()) => _cursorPos;
        updateText();
        updateCursor();
    }

    fun string placeholder() { return _placeholder; }
    fun void placeholder(string placeholder) { placeholder => _placeholder; }

    fun int focused() { return _focused; }

    // ==== Interaction ====

    fun void handleInput() {
        if (!_focused) return;

        frameCount++;

        if (GWindow.keyDown(GWindow.Key_Home)) {
            0 => _cursorPos;
            updateCursor();
        }
        else if (GWindow.keyDown(GWindow.Key_End)) {
            _value.length() => _cursorPos;
            updateCursor();
        }

        GWindow.keys() @=> int keys[];
        for (int k : keys) {
            (
                (k>=GWindow.Key_A && k<=GWindow.Key_Z) ||
                (k>=GWindow.Key_0 && k<=GWindow.Key_9) ||
                k==GWindow.Key_Space        ||
                k==GWindow.Key_Period       ||
                k==GWindow.Key_Comma        ||
                k==GWindow.Key_Slash        ||
                k==GWindow.Key_Backslash    ||
                k==GWindow.Key_Semicolon    ||
                k==GWindow.Key_LeftBracket  ||
                k==GWindow.Key_RightBracket ||
                k==GWindow.Key_Apostrophe   ||
                k==GWindow.Key_Minus        ||
                k==GWindow.Key_Equal        ||
                k==GWindow.Key_Backspace    ||
                k==GWindow.Key_Delete       ||
                k==GWindow.Key_Left         ||
                k==GWindow.Key_Right      
            ) => int isRepeatable;
            if (!isRepeatable) continue;

            if (k >= lastKey.size()) lastKey.size(k+1);
            if (lastKey[k]==0) { frameCount => lastKey[k]; }
            frameCount - lastKey[k] => int elapsed;
            
            if (elapsed != 0 && elapsed < repeatDelay) continue;
            if (elapsed >= repeatDelay && ((elapsed - repeatDelay) % repeatRate) != 0) continue;

            if (k == GWindow.Key_Backspace) {
                if (_cursorPos>0) { _value.erase(_cursorPos-1,1); _cursorPos--; updateText(); updateCursor(); }
            }
            else if (k == GWindow.Key_Delete) {
                if (_cursorPos<_value.length()) { _value.erase(_cursorPos,1); updateText(); updateCursor(); }
            }
            else if (k == GWindow.Key_Left) {
                if (_cursorPos>0) { _cursorPos--; updateCursor(); }
            }
            else if (k == GWindow.Key_Right) {
                if (_cursorPos<_value.length()) { _cursorPos++; updateCursor(); }
            }
            else if (k == GWindow.Key_Home) {
                0 => _cursorPos; updateCursor();
            }
            else if (k == GWindow.Key_End) {
                _value.length() => _cursorPos; updateCursor();
            } else {
                GWindow.key(GWindow.Key_LeftShift) || GWindow.key(GWindow.Key_RightShift) => int shift;
                0 => int ch;
                if (k>=GWindow.Key_A && k<=GWindow.Key_Z) {
                    (shift
                        ? ('A' + (k - GWindow.Key_A))
                        : ('a' + (k - GWindow.Key_A))
                    ) => ch;
                }
                else if (k>=GWindow.Key_0 && k<=GWindow.Key_9) {
                    if (shift) {
                        ")!@#$%^&*(" => string specials;
                        specials.charAt(k - GWindow.Key_0) => ch;
                    } else {
                        ('0' + (k - GWindow.Key_0)) => ch;
                    }
                }
                else if (k==GWindow.Key_Space)        { ' ' => ch; }
                else if (k==GWindow.Key_Period)       { shift ? '>' : '.' => ch; }
                else if (k==GWindow.Key_Comma)        { shift ? '<' : ',' => ch; }
                else if (k==GWindow.Key_Slash)        { shift ? '?' : '/' => ch; }
                else if (k==GWindow.Key_Backslash)    { shift ? '|' : '\\' => ch; }
                else if (k==GWindow.Key_LeftBracket)  { shift ? '{' : '[' => ch; }
                else if (k==GWindow.Key_RightBracket) { shift ? '}' : ']' => ch; }
                else if (k==GWindow.Key_Semicolon)    { shift ? ':' : ';' => ch; }
                else if (k==GWindow.Key_Apostrophe)   { shift ? '"' : '\'' => ch; }
                else if (k==GWindow.Key_Minus)        { shift ? '_' : '-' => ch; }
                else if (k==GWindow.Key_Equal)        { shift ? '+' : '=' => ch; }

                if (ch > 0) {
                    // safe split
                    (_cursorPos>0 ? _value.substring(0,_cursorPos) : "") => string prefix;
                    (_cursorPos<_value.length() ? _value.substring(_cursorPos) : "") => string suffix;
                    prefix.appendChar(ch) => prefix;
                    prefix + suffix => _value;
                    _cursorPos++;
                    updateText(); updateCursor();
                }
            }
        }
        // clear released keys
        for (0 => int k; k < lastKey.size(); k++) {
            if (!GWindow.key(k)) {
                0 => lastKey[k];
            }
        }
    }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_INPUT, @(1, 1, 1, 1)) => vec4 fieldColor;
        UIStyle.color(UIStyle.COL_INPUT_TEXT, @(0, 0, 0, 1)) => vec4 textColor;
        UIStyle.color(UIStyle.COL_INPUT_BORDER, @(0.3, 0.3, 0.3, 1)) => vec4 borderColor;
        UIStyle.color(UIStyle.COL_INPUT_PLACEHOLDER, @(textColor.x, textColor.y, textColor.z, textColor.w / 1.5)) => vec4 placeholderColor;
        UIStyle.color(UIStyle.COL_INPUT_CURSOR, @(0, 0, 0, 1)) => vec4 cursorColor;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_INPUT_SIZE, @(3, 0.4))) => vec2 fieldSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_INPUT_TEXT_SIZE, 0.15)) => float textSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_INPUT_BORDER_RADIUS, 0.1)) => float borderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_INPUT_BORDER_WIDTH, 0.05)) => float borderWidth;
        UIStyle.varString(UIStyle.VAR_INPUT_FONT, "") => string font;

        UIStyle.varVec2(UIStyle.VAR_INPUT_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_INPUT_Z_INDEX, 0.0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_INPUT_ROTATE, 0.0) => float rotate;

        if (_disabled) {
            UIStyle.color(UIStyle.COL_INPUT_DISABLED, fieldColor) => fieldColor;
            UIStyle.color(UIStyle.COL_INPUT_TEXT_DISABLED, textColor) => textColor;
            UIStyle.color(UIStyle.COL_INPUT_BORDER_DISABLED, borderColor) => borderColor;
        } else if (_focused) {
            UIStyle.color(UIStyle.COL_INPUT_FOCUSED, fieldColor) => fieldColor;
            UIStyle.color(UIStyle.COL_INPUT_BORDER_FOCUSED, borderColor) => borderColor;
        } else if (_state.hovered()) {
            UIStyle.color(UIStyle.COL_INPUT_HOVERED, fieldColor) => fieldColor;
            UIStyle.color(UIStyle.COL_INPUT_BORDER_HOVERED, borderColor) => borderColor;
        }
        
        gField.size(fieldSize);
        gField.color(fieldColor);
        gField.borderRadius(borderRadius);
        gField.borderWidth(borderWidth);
        gField.borderColor(borderColor);

        // Text styling
        gText.font(font);
        if (_value.length() > 0) {
            gText.color(textColor);
        } else {
            gText.color(placeholderColor);
        }
        gText.size(textSize);
        gText.maxWidth(fieldSize.x - 0.1);
        gText.posZ(0.1);
        gText.controlPoints(@(0, 0.5));
        
        // Position text to left side with padding
        fieldSize.x / 2.0 => float halfW;
        gText.posX(-halfW + 0.05); // 0.05 padding from left edge

        // Cursor styling
        @(0.02, textSize) => vec2 cursorSize;
        gCursor.size(cursorSize);
        gCursor.color(cursorColor);
        gCursor.borderRadius(0);
        gCursor.borderWidth(0);
        gCursor.posZ(0.2);
        
        // Show/hide cursor based on focus and blink state
        if (_focused && _cursorVisible) {
            gCursor --> this;
        } else if (gCursor.parent() != null) {
            gCursor --< this;
        }

        applyLayout(fieldSize, controlPoints, zIndex, rotate);
    }

    fun void updateText() {
        if (_value.length() > 0) {
            gText.text(_value);
        } else {
            gText.text(_placeholder);
        }
    }

    fun void updateCursor() {
        if (!_focused) return;

        gText.size() => float textSize;
        
        textSize * 0.6 => float charWidth;
        _cursorPos $ float * charWidth => float cursorOffset;
        
        gField.size().x / 2.0 => float halfW;
        -halfW + 0.05 + cursorOffset => float cursorX;
        
        gCursor.posX(cursorX);
    }

    fun void update() {
        _state.update();
        
        if (!_disabled) {
            if (_state.pressed() && !_focused) {
                true => _focused;
            } else if (_state.mouseDown() && !_state.hovered()) {
                false => _focused;
            }

            if (_focused) {
                handleInput();

                _cursorTimer + (2.0 / GG.fps()) => _cursorTimer;
                if (_cursorTimer >= 1.0) {
                    0.0 => _cursorTimer;
                    !_cursorVisible => _cursorVisible;
                }
            } else {
                false => _cursorVisible;
            }
        }

        updateUI();
    }
}
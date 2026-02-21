@import "../lib/UIUtil.ck"
@import "../lib/MouseState.ck"
@import "../lib/GComponent.ck"
@import "../gmeshes/GIcon.ck"
@import "../gmeshes/GRect.ck"
@import "../UIStyle.ck"

public class Button extends GComponent {
    GRect gBtn --> this;
    GText gText --> this;
    GIcon gIcon --> this;

    string _label;
    string _icon;

    new MouseState(this, gBtn) @=> _state;

    // ==== Getters and Setters ====    

    fun string label() { return _label; }
    fun void label(string label) { label => _label; }

    fun string icon() { return _icon; }
    fun void icon(string icon) {
        if (icon == "") {
            if (gIcon.parent() != null) { gIcon --< this; }
        } else if (_icon != icon) {
            gIcon.icon(icon);
            icon => _icon;
            if (gIcon.parent() == null) { gIcon --> this; }
        }
    }

    // ==== Update ====

    fun void updateUI() {
        // colors
        UIStyle.color(UIStyle.COL_BUTTON, @(0.7, 0.7, 0.7, 1)) => vec4 color;
        UIStyle.color(UIStyle.COL_BUTTON_BORDER, @(0, 0, 0, 1)) => vec4 borderColor;
        UIStyle.color(UIStyle.COL_BUTTON_TEXT, @(0, 0, 0, 1)) => vec4 textColor;
        UIStyle.color(UIStyle.COL_BUTTON_ICON, textColor) => vec4 iconColor;

        // vars (convert sizes from current unit system to world coordinates)
        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_BUTTON_SIZE, @(3, 0.5))) => vec2 size;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_BUTTON_TEXT_SIZE, 0.2)) => float textSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_BUTTON_ICON_SIZE, textSize)) => float iconSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_BUTTON_BORDER_RADIUS, 0)) => float borderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_BUTTON_BORDER_WIDTH, 0)) => float borderWidth;
        UIStyle.varString(UIStyle.VAR_BUTTON_FONT, "") => string font;
        UIStyle.varString(UIStyle.VAR_BUTTON_ICON_POSITION, UIStyle.LEFT) => string iconPos;

        UIStyle.varVec2(UIStyle.VAR_BUTTON_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_BUTTON_Z_INDEX, 0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_BUTTON_ROTATE, 0) => float rotate;

        // state
        if (_disabled) {
            UIStyle.color(UIStyle.COL_BUTTON_DISABLED, @(0.7, 0.7, 0.7, 0.5)) => color;
            UIStyle.color(UIStyle.COL_BUTTON_BORDER_DISABLED, borderColor) => borderColor;
            UIStyle.color(UIStyle.COL_BUTTON_TEXT_DISABLED, textColor) => textColor;
            UIStyle.color(UIStyle.COL_BUTTON_ICON_DISABLED, iconColor) => iconColor;
        } else if (_state.pressed()) {
            UIStyle.color(UIStyle.COL_BUTTON_PRESSED, @(color.x, color.y, color.z, color.a/4)) => color;
            UIStyle.color(UIStyle.COL_BUTTON_BORDER_PRESSED, borderColor) => borderColor;
            UIStyle.color(UIStyle.COL_BUTTON_TEXT_PRESSED, textColor) => textColor;
            UIStyle.color(UIStyle.COL_BUTTON_ICON_PRESSED, iconColor) => iconColor;
        } else if (_state.hovered()) {
            UIStyle.color(UIStyle.COL_BUTTON_HOVERED, @(color.x, color.y, color.z, color.a/2)) => color;
            UIStyle.color(UIStyle.COL_BUTTON_BORDER_HOVERED, borderColor) => borderColor;
            UIStyle.color(UIStyle.COL_BUTTON_TEXT_HOVERED, textColor) => textColor;
            UIStyle.color(UIStyle.COL_BUTTON_ICON_HOVERED, iconColor) => iconColor;
        }

        // background
        gBtn.size(size);
        gBtn.color(color);
        gBtn.borderRadius(borderRadius);
        gBtn.borderWidth(borderWidth);
        gBtn.borderColor(borderColor);

        // layout
        (_label != "") ? textSize * _label.length() * 0.5 : 0. => float textW;
        (_icon != "") ? iconSize : 0. => float iconW;
        0.2 * size.y => float spacing;
        if (textW == 0 || iconW == 0) { 0. => spacing; }
        textW + iconW + ((_label!="" && _icon!="") ? spacing : 0.) => float totalW;
        -totalW * 0.5 => float startX;
        startX + ((iconPos == UIStyle.RIGHT) ? textW + spacing + iconW*0.5 : iconW*0.5) => float iconX;
        startX + ((iconPos == UIStyle.RIGHT) ? textW*0.5 : iconW + spacing + textW*0.5) => float textX;

        // text
        if (_label != "") {
            if (gText.parent() == null) gText --> this;
            gText.font(font);
            gText.text(_label);
            gText.color(textColor);
            gText.size(textSize);
            gText.pos(@(textX, 0, 0.1));
        } else {
            if (gText.parent() != null) gText --< this;
        }

        // icon
        if (_icon != "") {
            if (gIcon.parent() == null) gIcon --> this;
            gIcon.sca(@(iconSize, iconSize, 1));
            gIcon.color(iconColor);
            gIcon.pos(@(iconX, 0, 0.1));
        } else {
            if (gIcon.parent() != null) gIcon --< this;
        }

        applyLayout(size, controlPoints, zIndex, rotate);
    }

    fun void update() {
        _state.update();
        updateUI();
    }
}

public class MomentaryButton extends Button {
    // ==== Getters and Setters ====

    fun int clicked() { return _disabled ? false : _state.clicked(); }
}

public class ToggleButton extends Button {
    // ==== Getters and Setters ====

    fun int toggled() { return _disabled ? false : _state.toggled(); }
    fun void toggled(int toggled) { _state.toggled(toggled); }

    // ==== Update ====

    fun void update() {
        _state.update();
        _state.pressed(_state.toggled());
        updateUI();
    }
}
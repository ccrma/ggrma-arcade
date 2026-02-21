@import "../lib/UIUtil.ck"
@import "../lib/MouseState.ck"
@import "../lib/GComponent.ck"
@import "../gmeshes/GRect.ck"
@import "../gmeshes/GIcon.ck"
@import "../UIStyle.ck"

public class Checkbox extends GComponent {
    GRect gBox --> this;
    GIcon gIcon --> this;

    string _icon;

    new MouseState(this, gBox) @=> _state;

    // ==== Getters and Setters ====

    fun void checked(int checked) { _state.toggled(checked); }
    fun int checked() { return _state.toggled(); }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_CHECKBOX, @(1, 1, 1, 1)) => vec4 boxColor;
        UIStyle.color(UIStyle.COL_CHECKBOX_BORDER, @(0.3, 0.3, 0.3, 1)) => vec4 borderColor;
        UIStyle.color(UIStyle.COL_CHECKBOX_ICON, @(1, 1, 1, 1)) => vec4 iconColor;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_CHECKBOX_SIZE, @(0.3, 0.3))) => vec2 boxSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_CHECKBOX_BORDER_RADIUS, 0)) => float borderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_CHECKBOX_BORDER_WIDTH, 0)) => float borderWidth;
        UIStyle.varString(UIStyle.VAR_CHECKBOX_ICON, me.dir() + "../assets/icons/check.png") => string icon;

        UIStyle.varVec2(UIStyle.VAR_CHECKBOX_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_CHECKBOX_Z_INDEX, 0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_CHECKBOX_ROTATE, 0) => float rotate;

        if (gIcon.parent() != null) { gIcon --< this; }

        if (_disabled) {
            UIStyle.color(UIStyle.COL_CHECKBOX_DISABLED, boxColor) => boxColor;
            UIStyle.color(UIStyle.COL_CHECKBOX_BORDER_DISABLED, borderColor) => borderColor;
            if (_state.toggled()) gIcon --> this;
        } else if (_state.toggled()) {
            UIStyle.color(UIStyle.COL_CHECKBOX_PRESSED, @(boxColor.x, boxColor.y, boxColor.z, boxColor.a/4)) => boxColor;
            UIStyle.color(UIStyle.COL_CHECKBOX_BORDER_PRESSED, borderColor) => borderColor;
            gIcon --> this;
        } else if (_state.hovered()) {
            UIStyle.color(UIStyle.COL_CHECKBOX_HOVERED, @(boxColor.x, boxColor.y, boxColor.z, boxColor.a/2)) => boxColor;
            UIStyle.color(UIStyle.COL_CHECKBOX_BORDER_HOVERED, borderColor) => borderColor;
        }

        gBox.size(boxSize);
        gBox.color(boxColor);
        gBox.borderRadius(borderRadius);
        gBox.borderWidth(borderWidth);
        gBox.borderColor(borderColor);

        0.2 => float pad;
        @(boxSize.x*(1-pad), boxSize.y*(1-pad)) => vec2 inner;
        gIcon.sca(inner);
        gIcon.color(iconColor);

        if (_icon != icon) {
            gIcon.icon(icon);
        }
        icon => _icon;

        applyLayout(boxSize, controlPoints, zIndex, rotate);
    }

    fun void update() {
        _state.update();
        updateUI();
    }
}
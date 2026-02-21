@import "../lib/UIUtil.ck"
@import "../lib/MouseState.ck"
@import "../lib/GComponent.ck"
@import "../gmeshes/GRect.ck"
@import "../UIStyle.ck"

public class Knob extends GComponent {
    GRect gKnob --> this;
    GRect gIndicator --> this;

    string _postfix;
    float _min;
    float _max;
    float _val;
    
    new MouseState(this, gKnob) @=> _state;

    vec3 _startMousePos;
    float _startValue;

    // ==== Getters and Setters ====

    fun string postfix() { return _postfix; }
    fun void postfix(string postfix) { postfix => _postfix; }

    fun float min() { return _min; }
    fun void min(float min) { min => _min; }

    fun float max() { return _max; }
    fun void max(float max) { max => _max; }

    fun float val() { return _val; }
    fun void val(float v) {
        Math.clampf(v, _min, _max) => _val;
        updateIndicator();
    }

    // ==== Interaction ====

    fun void drag(vec3 deltaPos) {
        1.0 => float sensitivity;
        (deltaPos.y + deltaPos.x) * sensitivity * (_max - _min) => float deltaValue;
        _startValue + deltaValue => float newVal;
        val(newVal);
    }

    // ==== Update ====

    fun void updateIndicator() {
        -0.75 * Math.PI => float angleMin;
        -2.25 * Math.PI => float angleMax;
        
        (_val - _min) / (_max - _min) => float t;
        angleMin + t * (angleMax - angleMin) => float angle;

        0.35 => float indicatorRadius;
        gKnob.size().x / 2.0 * indicatorRadius => float len;
        len * Math.cos(angle) => gIndicator.posX;
        len * Math.sin(angle) => gIndicator.posY;
        
        gIndicator.rotZ(angle + Math.PI/2);
    }

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_KNOB, @(0.7, 0.7, 0.7, 1)) => vec4 knobColor;
        UIStyle.color(UIStyle.COL_KNOB_BORDER, @(0.2, 0.2, 0.2, 1)) => vec4 knobBorderColor;
        UIStyle.color(UIStyle.COL_KNOB_INDICATOR, @(0.2, 0.2, 0.2, 1)) => vec4 indicatorColor;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_KNOB_SIZE, @(0.5, 0.5))) => vec2 knobSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_KNOB_BORDER_RADIUS, 1.0)) => float knobBorderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_KNOB_BORDER_WIDTH, 0.1)) => float knobBorderWidth;
        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_KNOB_INDICATOR_SIZE, @(0.04, 0.15))) => vec2 indicatorSize;

        UIStyle.varVec2(UIStyle.VAR_KNOB_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_KNOB_Z_INDEX, 0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_KNOB_ROTATE, 0) => float rotate;

        if (_disabled) {
            UIStyle.color(UIStyle.COL_KNOB_DISABLED, @(0.7, 0.7, 0.7, 1)) => knobColor;
            UIStyle.color(UIStyle.COL_KNOB_BORDER_DISABLED, @(0.7, 0.7, 0.7, 1)) => knobBorderColor;
            UIStyle.color(UIStyle.COL_KNOB_INDICATOR_DISABLED, @(0.7, 0.7, 0.7, 1)) => indicatorColor;
        } else if (_state.pressed()) {
            UIStyle.color(UIStyle.COL_KNOB_PRESSED, knobColor) => knobColor;
            UIStyle.color(UIStyle.COL_KNOB_BORDER_PRESSED, knobBorderColor) => knobBorderColor;
            UIStyle.color(UIStyle.COL_KNOB_INDICATOR_PRESSED, indicatorColor) => indicatorColor;
        } else if (_state.hovered()) {
            UIStyle.color(UIStyle.COL_KNOB_HOVERED, knobColor) => knobColor;
            UIStyle.color(UIStyle.COL_KNOB_BORDER_HOVERED, knobBorderColor) => knobBorderColor;
            UIStyle.color(UIStyle.COL_KNOB_INDICATOR_HOVERED, indicatorColor) => indicatorColor;
        }

        gKnob.size(knobSize);
        gKnob.color(knobColor);
        gKnob.borderRadius(knobBorderRadius);
        gKnob.borderWidth(knobBorderWidth);
        gKnob.borderColor(knobBorderColor);

        gIndicator.size(indicatorSize);
        gIndicator.color(indicatorColor);
        gIndicator.borderRadius(indicatorSize.x / 2);
        gIndicator.borderWidth(0);

        applyLayout(knobSize, controlPoints, zIndex, rotate);
    }


    fun void update() {
        _state.update();

        if (!_disabled) {
            if (_state.dragging()) {
                _state.mouseWorld() => vec3 currentMousePos;

                if (_state.clicked()) {
                    currentMousePos => _startMousePos;
                    _val => _startValue;
                } else {
                    currentMousePos - _startMousePos => vec3 deltaPos;
                    drag(deltaPos);
                }
            }
        }

        updateUI();
    }
}
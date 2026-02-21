@import "../lib/GComponent.ck"
@import "../lib/UIUtil.ck"
@import "../gmeshes/GRect.ck"
@import "../UIStyle.ck"

public class Meter extends GComponent {
    GRect gTrack --> this;
    GRect gFill --> this;

    float _min;
    float _max;
    float _val;

    // ==== Getters and Setters ====

    fun float min() { return _min; }
    fun void min(float min) { min => _min; }

    fun float max() { return _max; }
    fun void max(float max) { max => _max; }

    fun float val() { return _val; }
    fun void val(float v) {
        Math.clampf(v, _min, _max) => _val;
    }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_METER_TRACK, @(0.8, 0.8, 0.8, 1)) => vec4 trackColor;
        UIStyle.color(UIStyle.COL_METER_FILL, @(0.2, 0.8, 0.2, 1)) => vec4 fillColor;
        UIStyle.color(UIStyle.COL_METER_TRACK_BORDER, @(0.5, 0.5, 0.5, 1)) => vec4 trackBorderColor;

        // Convert sizes from current unit system to world coordinates
        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_METER_SIZE, @(3.0, 0.3))) => vec2 size;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_METER_BORDER_RADIUS, 0)) => float borderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_METER_BORDER_WIDTH, 0.05)) => float borderWidth;

        UIStyle.varVec2(UIStyle.VAR_METER_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_METER_Z_INDEX, 0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_METER_ROTATE, 0) => float rotate;

        // Track
        gTrack.size(size);
        gTrack.color(trackColor);
        gTrack.borderRadius(borderRadius);
        gTrack.borderWidth(borderWidth);
        gTrack.borderColor(trackBorderColor);

        if (_max != _min) {
            (_val - _min) / (_max - _min) => float norm;
            Math.clampf(norm, 0, 1) => norm;

            borderWidth * Math.min(size.x, size.y) => float borderW;
            size.x - borderW => float innerW;
            size.y - borderW => float innerH;
            innerW * norm => float fillW;

            -size.x/2.0 + borderW/2.0 + fillW/2.0 => float fillCenterX;

            borderRadius * Math.min(innerW, innerH) * 0.5 => float fillRadAbs;
            fillRadAbs / Math.min(fillW, innerH) => float fillRadFrac;

            gFill.size(@(fillW, innerH));
            gFill.color(fillColor);
            gFill.borderRadius(fillRadFrac);
            gFill.borderWidth(0);
            gFill.borderColor(@(0,0,0,0));
            gFill.posX(fillCenterX);
            gFill.posY(0);
            gFill.posZ(0.1);
        } else {
            gFill.size(@(0, 0));
        }

        applyLayout(size, controlPoints, zIndex, rotate);
    }

    fun void update() {
        updateUI();
    }
}
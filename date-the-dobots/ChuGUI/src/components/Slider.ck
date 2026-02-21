@import "../lib/UIUtil.ck"
@import "../lib/MouseState.ck"
@import "../lib/GComponent.ck"
@import "../gmeshes/GRect.ck"
@import "../UIStyle.ck"

public class Slider extends GComponent {
    GRect gTrack --> this;
    GRect gHandle --> this;

    string _postfix;
    float _min;
    float _max;
    float _val;

    0 => int _dragging;

    new MouseState(this, gHandle) @=> _state;

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
        updatePosition();
    }

    // ==== Interaction ====

    fun void drag(float norm) {
        if (norm < 0) 0 => norm;
        if (norm > 1) 1 => norm;
        _min + norm * (_max - _min) => float newVal;
        val(newVal);
    }

    // ==== Update ====

    fun void updatePosition() {
        (_val - _min) / (_max - _min) => float norm;
        gTrack.size().x * (norm - 0.5) => float xPos;
        gHandle.posX(xPos);
    }
    
    fun void updateUI() {
        UIStyle.color(UIStyle.COL_SLIDER_TRACK, @(0.7, 0.7, 0.7, 1)) => vec4 trackColor;
        UIStyle.color(UIStyle.COL_SLIDER_TRACK_BORDER, @(0, 0, 0, 1)) => vec4 trackBorderColor;
        UIStyle.color(UIStyle.COL_SLIDER_HANDLE, @(0, 0, 0, 1)) => vec4 handleColor;
        UIStyle.color(UIStyle.COL_SLIDER_HANDLE_BORDER, @(0, 0, 0, 1)) => vec4 handleBorderColor;

        // Convert sizes from current unit system to world coordinates
        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_SLIDER_TRACK_SIZE, @(3.5, 0.2))) => vec2 trackSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SLIDER_TRACK_BORDER_RADIUS, 0)) => float trackBorderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SLIDER_TRACK_BORDER_WIDTH, 0)) => float trackBorderWidth;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_SLIDER_HANDLE_SIZE, @(0.3, 0.3))) => vec2 handleSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SLIDER_HANDLE_BORDER_RADIUS, 0)) => float handleBorderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SLIDER_HANDLE_BORDER_WIDTH, 0)) => float handleBorderWidth;

        UIStyle.varVec2(UIStyle.VAR_SLIDER_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_SLIDER_Z_INDEX, 0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_SLIDER_ROTATE, 0) => float rotate;

        if (_disabled) {
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_DISABLED, @(0.7, 0.7, 0.7, 1)) => trackColor;
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_BORDER_DISABLED, @(0.7, 0.7, 0.7, 1)) => trackBorderColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_DISABLED, @(0.7, 0.7, 0.7, 1)) => handleColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_BORDER_DISABLED, @(0.7, 0.7, 0.7, 1)) => handleBorderColor;
        } else if (_state.pressed()) {
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_PRESSED, trackColor) => trackColor;
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_BORDER_PRESSED, trackBorderColor) => trackBorderColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_PRESSED, handleColor) => handleColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_BORDER_PRESSED, handleBorderColor) => handleBorderColor;
        } else if (_state.hovered()) {
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_HOVERED, trackColor) => trackColor;
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_BORDER_HOVERED, trackBorderColor) => trackBorderColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_HOVERED, handleColor) => handleColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_BORDER_HOVERED, handleBorderColor) => handleBorderColor;
        } 

        gTrack.size(trackSize);
        gTrack.color(trackColor);
        gTrack.borderRadius(trackBorderRadius);
        gTrack.borderWidth(trackBorderWidth);
        gTrack.borderColor(trackBorderColor);

        gHandle.size(handleSize);
        gHandle.color(handleColor);
        gHandle.borderRadius(handleBorderRadius);
        gHandle.borderWidth(handleBorderWidth);
        gHandle.borderColor(handleBorderColor);
        gHandle.posZ(0.2);

        applyLayout(@(trackSize.x + handleSize.x, handleSize.y), controlPoints, zIndex, rotate);
    }

    fun void update() {
        _state.update();
        
        if (!_disabled) {
            if (_state.dragging()) {
                _state.mouseWorld() => vec3 mouseWorld;
                this.posWorld().x => float cx;
                this.posWorld().y => float cy;
                mouseWorld.x - cx => float dx;
                mouseWorld.y - cy => float dy;

                // account for rotation
                this.rotZ() => float angle;
                Math.cos(angle) => float c;
                Math.sin(angle) => float s;

                dx * c + dy * s => float localX;

                gTrack.size().x / 2.0 => float halfW;

                (localX + halfW) / (2.0 * halfW) => float norm;

                drag(norm);
            }
        }

        updateUI();
    }
}

public class DiscreteSlider extends Slider {
    true => int recreateTicks;
    int _steps;
    GRect ticks[0];

    // ==== Getters and Setters ====

    fun int steps() {
        return _steps;
    }
    fun void steps(int s) {
        if (s < 2) 2 => s; // minimum 2 steps
        s != _steps => recreateTicks;
        s => _steps;
    }

    // ==== Display ====

    fun void createTicks() {
        for (0 => int i; i < ticks.size(); i++) {
            ticks[i] --< this;
        }
        ticks.clear();

        gTrack.size().x / 2.0 => float halfW;
        gTrack.borderRadius() => float cornerR;

        -halfW + cornerR => float startX;
        2 * (halfW - cornerR) => float span;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_SLIDER_TICK_SIZE, @(0.05, 0.2))) => vec2 tickSize;
        UIStyle.color(UIStyle.COL_SLIDER_TICK, @(0.2, 0.2, 0.2, 1)) => vec4 tickColor;

        for (0 => int i; i < _steps; i++) {
            GRect tick;
            tick.size(tickSize);
            tick.color(tickColor);
            tick.borderRadius(0);
            i $ float / (_steps - 1) => float tNorm;
            startX + tNorm * span => float xPos;
            tick.posX(xPos);
            tick.posY(0);
            tick.posZ(0);

            tick --> this;
            ticks << tick;
        }
    }

    fun void snapToNearestStep() {
        (_val - _min) / (_max - _min) => float norm;
        norm * (_steps - 1) => float stepFloat;
        Math.round(stepFloat) $ int => int nearestStep;
        
        Math.clampi(nearestStep, 0, _steps - 1) => nearestStep;
        nearestStep $ float / (_steps - 1) => float snappedNorm;
        _min + snappedNorm * (_max - _min) => float snappedVal;
        
        snappedVal => _val;
        updatePosition();
    }

    // ==== Interaction ====

    fun void drag(float norm) {
        if (norm < 0) 0 => norm;
        if (norm > 1) 1 => norm;
        
        norm * (_steps - 1) => float stepFloat;
        Math.round(stepFloat) $ int => int nearestStep;
        Math.clampi(nearestStep, 0, _steps - 1) => nearestStep;
        
        nearestStep $ float / (_steps - 1) => float snappedNorm;
        _min + snappedNorm * (_max - _min) => float newVal;
        
        newVal => _val;
        updatePosition();
    }

    // ==== Update ====

    fun void updatePosition() {
        gTrack.size().x / 2.0 => float halfW;
        gTrack.borderRadius() => float cornerR;

        -halfW + cornerR => float startX;
        2 * (halfW - cornerR) => float span;

        (_val - _min) / (_max - _min) => float tNorm;
        tNorm * (_steps - 1) => float rawIdx;
        Math.round(rawIdx) $ int => int idx;

        idx $ float / (_steps - 1) => float stepNorm;

        startX + stepNorm * span => float xPos;
        gHandle.posX(xPos);
    }
    
    fun void updateUI() {
        UIStyle.color(UIStyle.COL_SLIDER_TRACK, @(0.7, 0.7, 0.7, 1)) => vec4 trackColor;
        UIStyle.color(UIStyle.COL_SLIDER_TRACK_BORDER, @(0, 0, 0, 1)) => vec4 trackBorderColor;
        UIStyle.color(UIStyle.COL_SLIDER_HANDLE, @(0, 0, 0, 1)) => vec4 handleColor;
        UIStyle.color(UIStyle.COL_SLIDER_HANDLE_BORDER, @(0, 0, 0, 1)) => vec4 handleBorderColor;

        // Convert sizes from current unit system to world coordinates
        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_SLIDER_TRACK_SIZE, @(3.5, 0.2))) => vec2 trackSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SLIDER_TRACK_BORDER_RADIUS, 0)) => float trackBorderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SLIDER_TRACK_BORDER_WIDTH, 0)) => float trackBorderWidth;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_SLIDER_HANDLE_SIZE, @(0.3, 0.3))) => vec2 handleSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SLIDER_HANDLE_BORDER_RADIUS, 0)) => float handleBorderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SLIDER_HANDLE_BORDER_WIDTH, 0)) => float handleBorderWidth;

        UIStyle.varVec2(UIStyle.VAR_SLIDER_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_SLIDER_Z_INDEX, 0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_SLIDER_ROTATE, 0) => float rotate;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_SLIDER_TICK_SIZE, @(0.05, 0.2))) => vec2 tickSize;
        UIStyle.color(UIStyle.COL_SLIDER_TICK, @(0.2, 0.2, 0.2, 1)) => vec4 tickColor;

        if (_disabled) {
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_DISABLED, trackColor) => trackColor;
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_BORDER_DISABLED, trackBorderColor) => trackBorderColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_DISABLED, handleColor) => handleColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_BORDER_DISABLED, handleBorderColor) => handleBorderColor;
            UIStyle.color(UIStyle.COL_SLIDER_TICK_DISABLED, tickColor) => tickColor;
        } else if (_state.pressed()) {
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_PRESSED, trackColor) => trackColor;
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_BORDER_PRESSED, trackBorderColor) => trackBorderColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_PRESSED, handleColor) => handleColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_BORDER_PRESSED, handleBorderColor) => handleBorderColor;
            UIStyle.color(UIStyle.COL_SLIDER_TICK_PRESSED, tickColor) => tickColor;
        } else if (_state.hovered()) {
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_HOVERED, trackColor) => trackColor;
            UIStyle.color(UIStyle.COL_SLIDER_TRACK_BORDER_HOVERED, trackBorderColor) => trackBorderColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_HOVERED, handleColor) => handleColor;
            UIStyle.color(UIStyle.COL_SLIDER_HANDLE_BORDER_HOVERED, handleBorderColor) => handleBorderColor;
            UIStyle.color(UIStyle.COL_SLIDER_TICK_HOVERED, tickColor) => tickColor;
        }

        gTrack.size(trackSize);
        gTrack.color(trackColor);
        gTrack.borderRadius(trackBorderRadius);
        gTrack.borderWidth(trackBorderWidth);
        gTrack.borderColor(trackBorderColor);

        gHandle.size(handleSize);
        gHandle.color(handleColor);
        gHandle.borderRadius(handleBorderRadius);
        gHandle.borderWidth(handleBorderWidth);
        gHandle.borderColor(handleBorderColor);
        gHandle.posZ(0.2);

        if (recreateTicks) {
            createTicks();
            snapToNearestStep();
        }

        for (0 => int i; i < ticks.size(); i++) {
            ticks[i].size(tickSize);
            ticks[i].color(tickColor);
        }

        applyLayout(@(trackSize.x + handleSize.x, handleSize.y), controlPoints, zIndex, rotate);
    }

    fun void update() {
        _state.update();

        if (!_disabled) {
            if (_state.dragging()) {
                _state.mouseWorld() => vec3 mouseWorld;
                this.posWorld().x => float cx;
                this.posWorld().y => float cy;
                mouseWorld.x - cx => float dx;
                mouseWorld.y - cy => float dy;

                // account for rotation
                this.rotZ() => float angle;
                Math.cos(angle) => float c;
                Math.sin(angle) => float s;

                dx * c + dy * s => float localX;

                gTrack.size().x / 2.0 => float halfW;

                (localX + halfW) / (2.0 * halfW) => float norm;

                drag(norm);
            }
        }

        updateUI();
    }
}
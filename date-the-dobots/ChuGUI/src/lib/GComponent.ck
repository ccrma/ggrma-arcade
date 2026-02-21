@import "UIGlobals.ck"
@import "MouseState.ck"
@import "../UIStyle.ck"

public class GComponent extends GGen {
    vec2 _pos;

    int _frame;

    false => int _disabled;

    MouseState _state;

    // ==== Getters and Setters ====

    fun int frame() { return _frame; }
    fun void frame(int frame) { frame => _frame; }

    fun GGen pos(vec2 pos) {
        if (UIGlobals.posUnits == "WORLD") {
            pos => _pos;
        } else {
            GG.camera().NDCToWorldPos(@(pos.x, pos.y, 0)) => vec3 worldPos;
            @(worldPos.x, worldPos.y) => _pos;
        }
        return this;
    }

    fun int disabled() { return _disabled; }
    fun void disabled(int disabled) {
        disabled => _disabled;
        _state.disabled(_disabled);
    }

    // ==== Layout Helpers ====

    // Calculate position offset based on size and control points
    // Control points define where the origin is within the bounding box:
    // (0,0)=bottom-left, (0.5,0.5)=center, (1,1)=top-right
    fun vec2 controlPointOffset(vec2 size, vec2 controlPoints) {
        return @(size.x * (0.5 - controlPoints.x), size.y * (0.5 - controlPoints.y));
    }

    // Apply final position with control point offset, z-index, and rotation
    fun void applyLayout(vec2 size, vec2 controlPoints, float zIndex, float rotate) {
        controlPointOffset(size, controlPoints) => vec2 offset;
        this.posX(_pos.x + offset.x);
        this.posY(_pos.y + offset.y);
        this.posZ(zIndex);
        this.rotZ(rotate);
    }
}
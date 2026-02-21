@import "../gmeshes/GRect.ck"
@import "UIGlobals.ck"

public class UIUtil {
    // ==== Unit Conversion ====

    // Convert NDC size to world size
    fun static vec2 NDCToWorldSize(vec2 ndcSize) {
        GG.camera().NDCToWorldPos(@(ndcSize.x, ndcSize.y, 0)) => vec3 worldPos;
        GG.camera().NDCToWorldPos(@(0, 0, 0)) => vec3 origin;
        return @(Math.fabs(worldPos.x - origin.x), Math.fabs(worldPos.y - origin.y));
    }

    // Convert world size to NDC size
    fun static vec2 worldToNDCSize(vec2 worldSize) {
        GG.camera().worldPosToNDC(@(worldSize.x, worldSize.y, 0)) => vec3 ndcPos;
        GG.camera().worldPosToNDC(@(0, 0, 0)) => vec3 origin;
        return @(Math.fabs(ndcPos.x - origin.x), Math.fabs(ndcPos.y - origin.y));
    }

    // Convert size from current unit system to world coordinates
    // Respects the global sizeUnits() setting
    fun static vec2 sizeToWorld(vec2 size) {
        if (UIGlobals.sizeUnits == "WORLD") {
            return size;
        } else {
            return NDCToWorldSize(size);
        }
    }

    // Convert single float size from current unit system to world coordinates
    fun static float sizeToWorld(float size) {
        if (UIGlobals.sizeUnits == "WORLD") {
            return size;
        } else {
            NDCToWorldSize(@(size, size)) => vec2 worldSize;
            return worldSize.x;
        }
    }

    // Convert position from current unit system to world coordinates
    // Respects the global posUnits() setting
    fun static vec2 posToWorld(vec2 pos) {
        if (UIGlobals.posUnits == "WORLD") {
            return pos;
        } else {
            GG.camera().NDCToWorldPos(@(pos.x, pos.y, 0)) => vec3 worldPos;
            return @(worldPos.x, worldPos.y);
        }
    }

    // ==== Collision Detection ====

    fun static int hovered(GGen ggen, GRect gRect) {
        GG.camera().screenCoordToWorldPos(GWindow.mousePos(), 1) => vec3 mouseWorld;

        ggen.posWorld().x => float cx;
        ggen.posWorld().y => float cy;
        mouseWorld.x - cx => float dx;
        mouseWorld.y - cy => float dy;

        // account for rotation
        ggen.rotZ() => float angle;
        Math.cos(angle) => float c;
        Math.sin(angle) => float s;
        (dx * c + dy * s) => float localX;
        (-dx * s + dy * c) => float localY;

        gRect.size().x / 2.0 => float halfW;
        gRect.size().y / 2.0 => float halfH;

        gRect.pos().x => float rectLocalX;
        gRect.pos().y => float rectLocalY;

        localX - rectLocalX => float relX;
        localY - rectLocalY => float relY;

        if (relX < -halfW || relX > halfW || relY < -halfH || relY > halfH) {
            return 0;
        }

        gRect.borderRadius() => float cornerR;
        if (Math.fabs(relX) <= (halfW - cornerR) || Math.fabs(relY) <= (halfH - cornerR)) {
            return 1;
        }

        (relX > 0 ? halfW - cornerR : -halfW + cornerR) => float cx2;
        (relY > 0 ? halfH - cornerR : -halfH + cornerR) => float cy2;

        relX - cx2 => float dx2;
        relY - cy2 => float dy2;

        return (dx2 * dx2 + dy2 * dy2 <= cornerR * cornerR) ? 1 : 0;
    }
}
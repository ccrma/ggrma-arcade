@import "../ChuGUI/src/ChuGUI.ck"

public class Camera {
    // Get current world width
    fun static float worldWidth() {
        return ChuGUI.NDCToWorldSize(@(2, 0)).x;
    }

    // Get current world height
    fun static float worldHeight() {
        return ChuGUI.NDCToWorldSize(@(0, 2)).y;
    }

    // Convert world to NDC position
    fun static vec2 WorldToNDCPos(vec2 world) {
        return GG.camera().worldPosToNDC(@(world.x, world.y, 0)) $ vec2;
    }

    // Convert NDC to world position
    fun static vec2 NDCToWorldPos(vec2 ndc) {
        return GG.camera().NDCToWorldPos(@(ndc.x, ndc.y, 0)) $ vec2;
    }
}

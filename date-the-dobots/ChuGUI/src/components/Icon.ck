@import "../lib/GComponent.ck"
@import "../lib/UIUtil.ck"
@import "../gmeshes/GIcon.ck"
@import "../UIStyle.ck"

public class Icon extends GComponent {
    GIcon gIcon --> this;
    string _icon;

    // ==== Getters and Setters ====

    fun string icon() { return _icon; }
    fun void icon(string icon) {
        if (_icon != icon) {
            gIcon.icon(icon);
        }
        icon => _icon;
    }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_ICON, Color.WHITE) => vec4 color;

        // Convert size from current unit system to world coordinates
        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_ICON_SIZE, @(1, 1))) => vec2 size;
        UIStyle.varFloat(UIStyle.VAR_ICON_TRANSPARENT, 1) $ int => int transparent;
        UIStyle.varString(UIStyle.VAR_ICON_SAMPLER, UIStyle.LINEAR) => string samplerOption;

        UIStyle.varFloat(UIStyle.VAR_ICON_WRAP, -1) $ int => int wrap;
        UIStyle.varFloat(UIStyle.VAR_ICON_WRAP_U, TextureSampler.Wrap_Repeat) $ int => int wrapU;
        UIStyle.varFloat(UIStyle.VAR_ICON_WRAP_V, TextureSampler.Wrap_Repeat) $ int => int wrapV;
        UIStyle.varFloat(UIStyle.VAR_ICON_WRAP_W, TextureSampler.Wrap_Repeat) $ int => int wrapW;

        UIStyle.varVec2(UIStyle.VAR_ICON_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_ICON_Z_INDEX, 0.0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_ICON_ROTATE, 0.0) => float rotate;

        gIcon.sca(size);
        gIcon.color(color);
        gIcon.transparent(transparent);

        samplerOption == UIStyle.NEAREST ? TextureSampler.nearest() : TextureSampler.linear() @=> TextureSampler sampler;
        wrapU => sampler.wrapU;
        wrapV => sampler.wrapV;
        wrapW => sampler.wrapW;
        if (wrap != -1) {
            wrap => sampler.wrapU => sampler.wrapV => sampler.wrapW;
        }
        gIcon.sampler(sampler);

        applyLayout(size, controlPoints, zIndex, rotate);
    }

    fun void update() {
        updateUI();
    }
}
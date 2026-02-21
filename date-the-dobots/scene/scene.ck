@import "../ChuGUI/src/ChuGUI.ck"
@import "../lib/dialogManager.ck"

public class Scene {
    string assetPath;

    DialogManager dm;

    fun void init(Player @ player, Prompt prompts[]) {
        // To be overridden by subclasses
    }

    fun void deinit() {
        // to be overridden
    }

    fun void update(ChuGUI gui) {
        render(gui);
    }

    fun void render(ChuGUI gui) {
        UIStyle.pushVar(UIStyle.VAR_ICON_SIZE, @(2, 2));
        UIStyle.pushVar(UIStyle.VAR_ICON_Z_INDEX, -1);
        gui.icon(assetPath, @(0, 0));
        UIStyle.popVar(2);
    }

    fun DialogManager dialogManager() {
        return dm;
    }
}

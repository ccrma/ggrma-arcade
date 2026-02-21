@import "../ChuGUI/src/ChuGUI.ck"
@import "camera.ck"
@import "../ui/portrait.ck"

public class Player {
    Portrait portrait;
    string _name;

    me.dir() + "../assets/human/human-blink.png" => string blink_path;
    me.dir() + "../assets/human/human.png" => string normal_path;
    int eyes_closed;

    me.dir() + "../assets/human/human-shocked.png" => string shock_path;

    fun Player(string name, string assetPath) {
        name => _name;

        // Set up portrait on left side
        Camera.worldWidth() / -2 + 2.5 => float leftX;
        portrait.assetPath(assetPath);
        portrait.size(@(1640./1640, 2360./1640) * 5);
        portrait.pos(@(leftX, -0.6));
        portrait.zIndex(1.5);
        portrait.visible(true);
    }

    5 => float blink_cd_curr;
    fun void update(ChuGUI gui) {
        GG.dt() => float dt;
        portrait.update(gui);

        dt -=> blink_cd_curr;
        if (blink_cd_curr < 0) {
            !eyes_closed => eyes_closed;
            if (eyes_closed) {
                blink_path => portrait._assetPath;
                Math.random2f(.03,.06) => blink_cd_curr;
            } else {
                normal_path => portrait._assetPath; 
                Math.random2f(3,7) => blink_cd_curr;
            }
        }
    }

    fun string name() {
        return _name;
    }

    fun void show() {
        spork ~ portrait.show();
    }

    fun void hide() {
        spork ~ portrait.hide();
    }

    fun void highlight() {
        portrait.highlight();
    }

    fun void dim() {
        portrait.dim();
    }
}

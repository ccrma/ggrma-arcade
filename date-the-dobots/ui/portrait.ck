@import "../ChuGUI/src/ChuGUI.ck"
@import "../lib/camera.ck"

public class Portrait {
    string _assetPath;
    vec2 _pos;
    vec2 _size;
    float _scale;
    float _zIndex;
    int _flipX;

    // Highlight/dim state
    float _brightness;
    float _targetBrightness;
    0.2 => float dimBrightness;   // Brightness when not speaking
    1.0 => float fullBrightness;  // Brightness when speaking

    float _alpha;
    float _slideOffset;
    int _visible;

    0.8 => float defaultHeightRatio;

    SndBuf fadeInSnd(me.dir() + "../assets/audio/fade_in.wav") => dac;
    0 => fadeInSnd.rate;
    0.2 => fadeInSnd.gain;
    SndBuf fadeOutSnd(me.dir() + "../assets/audio/fade_out.wav") => dac;
    0 => fadeOutSnd.rate;
    0.2 => fadeOutSnd.gain;

    fun Portrait() {
        @(0, 0) => _pos;
        @(1, 1) => _size;
        1.0 => _scale;
        1.5 => _zIndex;
        false => _flipX;
        1.0 => _brightness;
        1.0 => _targetBrightness;
        0.0 => _alpha;
        2.0 => _slideOffset;
        false => _visible;
    }

    fun void update(ChuGUI gui) {
        render(gui);
    }

    fun void render(ChuGUI gui) {
        if (_assetPath == "" || _alpha <= 0.001) return;

        0.15 => float lerpSpeed;
        _brightness + (_targetBrightness - _brightness) * lerpSpeed => _brightness;

        gui.units(ChuGUI.WORLD);

        Camera.worldHeight() * defaultHeightRatio => float targetHeight;
        (targetHeight * _size.x / _size.y) => float targetWidth;

        (targetWidth * _scale) => float scaledWidth;
        (targetHeight * _scale) => float scaledHeight;

        _flipX ? -scaledWidth : scaledWidth => scaledWidth;

        Camera.worldHeight() / -2 => float bottomY;
        (_pos.x < 0 ? -_slideOffset : _slideOffset) => float slideX;

        UIStyle.pushColor(UIStyle.COL_ICON, @(_brightness, _brightness, _brightness, _alpha));
        UIStyle.pushVar(UIStyle.VAR_ICON_CONTROL_POINTS, @(0.5, 0));
        UIStyle.pushVar(UIStyle.VAR_ICON_Z_INDEX, _zIndex);
        UIStyle.pushVar(UIStyle.VAR_ICON_SIZE, @(_size.x, _size.y));
        gui.icon(_assetPath, @(_pos.x + slideX, bottomY + _pos.y));
        UIStyle.popVar(3);
        UIStyle.popColor();

        gui.units(ChuGUI.NDC);
    }

    fun void assetPath(string path) {
        path => _assetPath;
    }

    fun string assetPath() {
        return _assetPath;
    }

    fun void pos(vec2 pos) {
        pos => _pos;
    }

    fun vec2 pos() {
        return _pos;
    }

    fun void size(vec2 size) {
        size => _size;
    }

    fun vec2 size() {
        return _size;
    }

    fun void zIndex(float z) {
        z => _zIndex;
    }

    fun float zIndex() {
        return _zIndex;
    }

    fun void flipX(int flip) {
        flip => _flipX;
    }

    fun int flipX() {
        return _flipX;
    }

    fun void heightRatio(float ratio) {
        ratio => defaultHeightRatio;
    }

    fun void playFadeIn() {
        fadeInSnd.length() => now;
    }

    fun void playFadeOut() {
        1 => fadeOutSnd.rate;
        0 => fadeOutSnd.pos;
        fadeOutSnd.length() => now;
    }

    fun void show() {
        // spork ~ playFadeIn();
        if (_visible) return;

        1 => fadeInSnd.rate;
        0 => fadeInSnd.pos;

        true => _visible;
        45 => int frames;
        2.0 => float startOffset;
        for (int i; i <= frames; i++) {
            (i * 1.0) / frames => float t;
            1.0 - Math.pow(1.0 - t, 3) => float eased;
            eased => _alpha;
            startOffset * (1.0 - eased) => _slideOffset;
            GG.nextFrame() => now;
        }
        1.0 => _alpha;
        0.0 => _slideOffset;
    }

    int hide_in_process;
    fun void hide() {
        if (hide_in_process || !_visible) return;
        true => hide_in_process;

        // spork ~ playFadeOut();
        1 => fadeOutSnd.rate;
        0 => fadeOutSnd.pos;

        30 => int frames;
        2.0 => float endOffset;
        for (int i; i <= frames; i++) {
            (i * 1.0) / frames => float t;
            Math.pow(t, 2) => float eased;
            1.0 - eased => _alpha;
            endOffset * eased => _slideOffset;
            GG.nextFrame() => now;
        }
        0.0 => _alpha;
        endOffset => _slideOffset;
        false => _visible;

        false => hide_in_process;
    }

    fun float scale() {
        return _scale;
    }

    fun void scale(float s) {
        s => _scale;
    }

    fun float alpha() {
        return _alpha;
    }

    fun void alpha(float a) {
        a => _alpha;
    }

    fun int visible() {
        return _visible;
    }

    fun void visible(int v) {
        v => _visible;
        if (v) {
            1.0 => _alpha;
            0.0 => _slideOffset;
        } else {
            0.0 => _alpha;
            2.0 => _slideOffset;
        }
    }

    fun void highlight() {
        fullBrightness => _targetBrightness;
    }

    fun void dim() {
        dimBrightness => _targetBrightness;
    }

    fun float brightness() {
        return _brightness;
    }

    fun void brightness(float b) {
        b => _brightness;
        b => _targetBrightness;
    }

    fun int isHighlighted() {
        return _targetBrightness >= fullBrightness;
    }
}

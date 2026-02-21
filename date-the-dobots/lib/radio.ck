@import "../ChuGUI/src/ChuGUI.ck"
@import "radioFilter.ck"
@import "fillShader.ck"

public class RadioMechanic {
    ChuGUI gui;

    .4 * Color.GREEN => static vec3 SELECTED_COLOR;
    .2 * Color.RED => static vec3 DEFAULT_COLOR;

    QuestionMark mark;
    mark.sca(1.5);
    mark.posZ(3.5);
    22::second => dur REPSONSE_TIME_LIMIT;
    1 => float response_warn_cd;
    0 => float response_warn_curr;

    float val;

    @(1., 1.) => vec2 _scale;
    1 => float _textScale;
    vec2 sliderSize;

    int numOptions;
    string optionLabels[0];
    int optionNumListens[0];

    ["4", "8", "12", "16"] @=> string radioNumbers[];

    Spring rot_spring(0, 3500, 12);

    float dotX[0];

    // Selection threshold - how close slider needs to be to a dot to "select" it
    0.05 => float selectThreshold;

    // Currently selected option index (-1 if none)
    -1 => int _selectedIndex;

    // Whether the radio is active (for dialogue choices)
    0 => int _active;
    int _powered_on;
    time _activate_time;

    // Position offset for rendering
    vec2 _position;    // position of radio inside player character

        // positions of zoomed-in radio
    @(0, 2 * GG.camera().viewSize()) => vec2 start_pos;
    start_pos => vec2 target_pos;
    start_pos => vec2 mark_start_pos;
    start_pos => vec2 mark_target_pos;

    // tween animation time (for entry/exit of zoomed radio)
    .6::second => dur ANIM_TIME;

    // audio
    SndBuf audio[0];
    Pan2   pan[0];
    RadioFilter radio_left => dac.left;
    RadioFilter radio_right => dac.right;
    CNoise n => LPF noise(600, 1); noise => radio_left; noise => radio_right; 0 => noise.gain;
    string audioFiles[0];
    string _audioBasePath;
    time loop_time[0];
    1::second => dur LOOP_DUR;

    256 => int WINDOW_SIZE;
    2.63 => float WAVEFORM_Y;
    2.1 => float DISPLAY_WIDTH;
    GLines waveform; waveform.width(.025);
    waveform.posY( WAVEFORM_Y );
    waveform.posX(-3.5);
    waveform.color(Color.WHITE);

    dac => Flip accum => blackhole;
    WINDOW_SIZE => accum.size;
    Windowing.hann(WINDOW_SIZE) @=> float window[];

    float samples[0];
    complex response[0];
    vec2 positions[WINDOW_SIZE];

    fun RadioMechanic(ChuGUI gui) {
        gui @=> this.gui;
    }

    // map audio buffer to 3D positions
    UI_Float waveform_zeno(.3);
    4 => float waveform_sca;
    fun void map2waveform( float in[], vec2 out[] )
    {
        if( in.size() != out.size() ) return;
        
        // mapping to xyz coordinate
        int i;
        DISPLAY_WIDTH => float width;
        for( auto s : in )
        {
            // space evenly in X
            -width/2 + width/WINDOW_SIZE*i => out[i].x;
            // map y, using window function to taper the ends
            waveform_zeno.val() * (s * waveform_sca * window[i] - out[i].y) +=> out[i].y;
            // increment
            i++;
        }
    }

    // sfx
    Gain sfx_gain => dac;

    SndBuf radio_on(me.dir() + "../assets/audio/radio-on-button.wav") => sfx_gain;
    0 => radio_on.rate;
    SndBuf radio_static(me.dir() + "../assets/audio/radio-static.wav") => sfx_gain;
    0 => radio_static.rate; 1 => radio_static.loop;
    SndBuf radio_hum(me.dir() + "../assets/audio/radio-hum.wav") => sfx_gain;
    0 => radio_hum.rate; 1 => radio_hum.loop;
    SndBuf radio_button_click(me.dir() + "../assets/audio/radio-button-click.wav") => sfx_gain; 
    0 => radio_button_click.rate;
    SndBuf radio_off_button(me.dir() + "../assets/audio/radio-off-button.wav") => sfx_gain; 
    0 => radio_off_button.rate; 0 => radio_off_button.loop;

    SndBuf radio_falling_1(me.dir() + "../assets/audio/crates_falling_1.wav") => sfx_gain;
    0 => radio_falling_1.rate;
    SndBuf radio_falling_2(me.dir() + "../assets/audio/crates_falling_2.wav") => sfx_gain;
    0 => radio_falling_2.rate;


    fun RadioMechanic() {
        0 => numOptions;
        @(0.5, 0.01) => sliderSize;
    }

    fun RadioMechanic(int numOptions) {
        numOptions => this.numOptions;
        @(0.5, 0.01) => sliderSize;
    }

    fun RadioMechanic(int numOptions, vec2 scale) {
        numOptions => this.numOptions;
        scale => _scale;
    }

    fun void init() {
        spork ~ keyboardHandler();
    }

    fun void setAudioBasePath(string path) {
        path => _audioBasePath;
    }

    fun void loadAudioForLabels(string labels[]) {
        // Clear existing audio
        for (int i; i < pan.size(); i++) {
            pan[i].left =< radio_left;
            pan[i].right =< radio_right;
        }
        audioFiles.clear();

        while (pan.size() < labels.size()) {
            audio << new SndBuf;
            pan << new Pan2;
            loop_time << now;
        }

        for (int i; i < labels.size(); i++) {
            labels[i].trim().lower() + ".wav" => string filename;
            "/voice0/" => string dir;
            if (maybe) {
                "/voice1/" => dir;
            }
            _audioBasePath + dir + filename => string filepath;
            audioFiles << filepath;
            audio[i] => pan[i];
            pan[i].left => radio_left;
            pan[i].right => radio_right;

            audio[i].read(filepath);
            audio[i].loop(0);
            0 => audio[i].gain;

            now + audio[i].length() + LOOP_DUR => loop_time[i];
        }
    }

    fun void setOptions(string labels[]) {
        optionLabels.clear();
        optionNumListens.clear();
        dotX.clear();

        labels.size() => numOptions;
        @(0.5 * _scale.x, 0.01 * _scale.y) => sliderSize;

        for (int i; i < numOptions; i++) {
            optionLabels << labels[i];
            optionNumListens << 0;
        }

        // Randomize dot positions - each dot in its own segment
        // dotX contains normalized positions [0, 1]
        .12 => float PAD;  // min pad between options to prevent overlap
        (1 - numOptions * PAD) / numOptions => float range; // range for each dot
        .5*PAD => float base;
        for (int i; i < numOptions; i++) {
            dotX << base + Math.random2f(0, range);
            range + PAD +=> base;
        }

        // Load audio files based on the labels
        loadAudioForLabels(labels);

        // Reset slider to middle
        0.5 => val;
        -1 => _selectedIndex;
    }

    fun void setPosition(vec2 pos) {
        pos => _position;
    }

    fun float easeOutElastic(float x) {
        (2 * Math.PI) / 3 => float c4;

        if (x < 0) return 0;
        if (x >= 1) return 1;
        return Math.pow(2, -10 * x) * Math.sin((x * 10 - 0.75) * c4) + 1;
    }

    fun float easeInBack(float x) {
        1.70158 => float c1;
        c1 + 1 => float c3;
        return Math.clampf(c3 * x * x * x - c1 * x * x, 0, 1);
    }

    // fun void easeOutBack(x: number): number {
    //     const c1 = 1.70158;
    //     const c3 = c1 + 1;
    //     return 1 + c3 * Math.pow(x - 1, 3) + c1 * Math.pow(x - 1, 2);
    // }

    fun float easeOutQuad(float x) {
        Math.clampf(x, 0, 1) => x;
        return 1 - (1 - x) * (1 - x);
    }

    fun float easeOutBounce(float x) {
        // 7.5625 => float n1;
        // 2.75 => float d1;
        // if (x > 1) return 1;
        // if (x < 1 / d1) {
        //     return n1 * x * x;
        // } 
        // else if (x < 2 / d1) {
        //     return n1 * (1.5 / d1 -=> x) * x + 0.75;
        // } 
        // else if (x < 2.5 / d1) {
        //     return n1 * (2.25 / d1 -=> x) * x + 0.9375;
        // } 
        // else {
        //     return n1 * (2.625 / d1 -=> x) * x + 0.984375;
        // }

        if (x > 1) return 1;
        if (x < .75) {
            return 1 + (16.0/9) * (x - .75) * (x + .75);
        }
        else {
            .875 -=> x;
            return 1 + 3.5 * (x - .125) * (x + .125);
        }
        
    }

    fun void activate() {
        if (_active) return;
        spork ~ activateShred();
    }

    fun void activateShred() {
        1 => _active;
        now => _activate_time;
        mark --> GG.scene();

        // set start and end pos
        @(  
            0,
            .25 * GG.camera().viewSize()
        ) => start_pos;
        @(0, 0) => target_pos;

        @(  
            1.5,
            .75 * GG.camera().viewSize()
        ) => mark_start_pos;
        @(1.5, 1.5) => mark_target_pos;

        // Unmute all audio when activated
        for (int i; i < audio.size(); i++) {
            1.0 => audio[i].gain;
        }

        { // sfx
            .75 *  ANIM_TIME => now;

            SndBuf@ falling;
            if (maybe) radio_falling_1 @=> falling;
            else radio_falling_2 @=> falling;
            0 => falling.pos;
            1 => falling.rate;
            rot_spring.pull(.12);

            .8 * ANIM_TIME => now;

            0 => radio_on.pos;
            1 => radio_on.rate;
            1 => radio_on.gain;
            .12::second => now;
            waveform --> GG.scene();
            1 => radio_static.rate;
            1 => radio_hum.rate;
            1 => radio_left.gain;
            1 => radio_right.gain;
            true => _powered_on;
        }
    }

    fun void deactivate() {
        spork ~ deactivateShred();
    }

    fun void deactivateShred() {
        if (!_active) return;

        0 => curr_vel; // lock selection bar

        .5::second => now;

        0 => _active;
        rot_spring.pull(.12);

        // flip start and end pos to lerp back up
        start_pos => vec2 tmp;
        target_pos => start_pos;
        tmp => target_pos;
        // update start time
        now => _activate_time;

        // radio off sfx
        0 => radio_off_button.pos;
        1 => radio_off_button.rate;

        .2::second => now;
        false => _powered_on;

        // Mute all audio when deactivated
        for (int i; i < audio.size(); i++) {
            0 => audio[i].gain;
        }
        0 => radio_left.gain;
        0 => radio_right.gain;
        0 => radio_on.gain;
        0 => radio_static.gain;
        0 => radio_hum.gain;

        if (waveform.parent() != null) {
            waveform --< GG.scene();
        }
    }

    fun int isActive() {
        return _active;
    }

    fun void update() {
        GG.dt() => float dt;
        rot_spring.update(dt);

        slider("radio", _scale, _position, 3.0, false, false);
        UIStyle.pushColor(UIStyle.COL_RECT, @(0, 0, 0, _brightness));
        UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(0.3, 0.175));
        UIStyle.pushVar(UIStyle.VAR_RECT_TRANSPARENT, true);
        UIStyle.pushVar(UIStyle.VAR_RECT_Z_INDEX, 3.5);
        gui.rect(@(-0.575, 0.4));
        UIStyle.popVar(3);
        UIStyle.popColor();
        if (_active && numOptions > 0) {
            updateSelection();
            map2waveform( samples, positions );
            waveform.positions( positions );
            updateAudio();

            // update response time limit
            (now - _activate_time) / REPSONSE_TIME_LIMIT => mark.fill;
            if (mark.fill() > .5 && mark.fill() < 1.0) {
                dt -=> response_warn_curr;
                if (response_warn_curr < 0) {
                    response_warn_cd => response_warn_curr;
                    mark.warn();
                }
            }
        }
        render();
    }

    fun int outOfTime() {
        return _active && mark.fill() > 1;
    }

    fun float trunc_fallof(float x, float m) {
        if (x > m) return 0.0;
        m /=> x;
        return (x - 2.0) * x + 1.0;
    }

    fun void updateSelection() {
        -1 => _selectedIndex;

        for (int i; i < numOptions; i++) {
            dotX[i] => float dotPos;
            Math.fabs(val - dotPos) => float dist;

            if (dist < selectThreshold) {
                i => _selectedIndex;
                break;
            }
        }
    }

    0.2 => float SAMPLE_RADIUS; // max dist threshold (on a normalized scale 0-1) for hearing a sample
    fun void updateAudio() {
        if (!_powered_on) return;

        float total_sample_gain;
        for (int i; i < audio.size() && i < numOptions; i++) {
            dotX[i] => float dotPos;
            (val - dotPos) => float sample_dist;

            // gain falloff
            trunc_fallof(Math.fabs(sample_dist), SAMPLE_RADIUS) => audio[i].gain;
            audio[i].gain() +=> total_sample_gain;

            // panning
            Math.remap(sample_dist, -SAMPLE_RADIUS, SAMPLE_RADIUS, 1, -1) => pan[i].pan;

            // loop audio if needed
            if (now > loop_time[i]) {
                0 => audio[i].pos;
                now + LOOP_DUR + audio[i].length() => loop_time[i];

                // check if the cursor is on this one
                if (_selectedIndex == i) {
                    optionNumListens[i]++;
                }
            }
        }

        // radio static
        if (_powered_on && _active) {
            1.0 * Math.pow(Math.max(0.2, 1 - total_sample_gain), 1) => radio_static.gain => radio_hum.gain;
        }
    }

    // do audio stuff
    fun void doAudio()
    {
        while( true )
        {
            // upchuck to process accum
            accum.upchuck();
            // get the last window size samples (waveform)
            accum.output( samples );
            WINDOW_SIZE::samp => now;
        }
    } spork ~ doAudio();

    fun int getSelectedIndex() {
        return _selectedIndex;
    }

    fun void playSelectionSfx() {
        0 => radio_button_click.pos;
        1 => radio_button_click.rate;
    }

    fun int hasSelection() {
        if (!_powered_on) return false;
        return _selectedIndex >= 0;
    }
    
    0.8 => float _brightness;
    fun void dim() {
        while(_brightness < 0.799) {
            GG.nextFrame() => now;
            0.15 => float lerpSpeed;
            _brightness + (0.8 - _brightness) * lerpSpeed => _brightness;
        }
        0.8 => _brightness;
    }

    fun void highlight() {
        while(_brightness > 0.01) {
            GG.nextFrame() => now;
            0.15 => float lerpSpeed;
            _brightness + (0.0 - _brightness) * lerpSpeed => _brightness;
        }
        0.0 => _brightness;
    }

    fun void slider(string id, vec2 scale, vec2 pos, float z_index, int show_text, int spring) {
        @(0.5 * scale.x, 0.01 * scale.y) => vec2 localSliderSize;

        // Scale factor from base sliderSize to this slider's size
        scale.x / _scale.x => float scaleRatio;

        spring ? rot_spring.x : 0. => float rotZ;

        // dots with option labels
        for (int i; i < dotX.size(); i++) {
            Math.remap(dotX[i], 0, 1, -sliderSize.x / 2, sliderSize.x / 2) => float dot_x;
            dot_x * scaleRatio + pos.x => float label_x;
            // Highlight selected dot
            if (i == _selectedIndex) {
                UIStyle.pushColor(UIStyle.COL_RECT, SELECTED_COLOR);
            } else {
                UIStyle.pushColor(UIStyle.COL_RECT, DEFAULT_COLOR);
            }
            UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(0.02 * scale.x, 0.015 * scale.y));
            UIStyle.pushVar(UIStyle.VAR_RECT_Z_INDEX, z_index - 0.05);
            UIStyle.pushVar(UIStyle.VAR_RECT_ROTATE, rotZ);
            gui.rect(@(label_x, -0.01 + pos.y));
            UIStyle.popVar(3);
            UIStyle.popColor();

            if (show_text && optionNumListens[i] > 0) { // text labels
                UIStyle.pushColor(UIStyle.COL_LABEL, @(0.5, 0.5, 0.5));
                UIStyle.pushVar(UIStyle.VAR_LABEL_SIZE, 0.02 * scale.x * _textScale);
                UIStyle.pushVar(UIStyle.VAR_LABEL_Z_INDEX, z_index);
                UIStyle.pushVar(UIStyle.VAR_LABEL_ROTATE, rotZ);

                Math.max(1, 100 / Math.pow(2, optionNumListens[i])) => float antialias;

                UIStyle.pushVar(UIStyle.VAR_LABEL_ANTIALIAS, antialias);
                gui.label(optionLabels[i], @(label_x, pos.y - .05 * scale.y));
                UIStyle.popVar(4);
                UIStyle.popColor();
            }
        }

        { // numbers (radio dial markings)
            UIStyle.pushColor(UIStyle.COL_LABEL, @(0.5, 0.5, 0.5));
            UIStyle.pushVar(UIStyle.VAR_LABEL_SIZE, 0.04 * scale.x);
            UIStyle.pushVar(UIStyle.VAR_LABEL_Z_INDEX, z_index);
            UIStyle.pushVar(UIStyle.VAR_LABEL_ROTATE, rotZ);

            for (int i; i < radioNumbers.size(); i++) {
                -localSliderSize.x / 2. + (i * 1.0) / (radioNumbers.size() - 1) * localSliderSize.x => float xPos;
                gui.label(radioNumbers[i], @(xPos + pos.x, 0.03 * scale.y + pos.y));
            }

            UIStyle.popVar(3);
            UIStyle.popColor();
        }

        // slider
        if (_selectedIndex >= 0) {
            UIStyle.pushColor(UIStyle.COL_SLIDER_HANDLE, SELECTED_COLOR);
        } else {
            UIStyle.pushColor(UIStyle.COL_SLIDER_HANDLE, DEFAULT_COLOR);
        }
        UIStyle.pushVar(UIStyle.VAR_SLIDER_TRACK_SIZE, @(0.5 * scale.x , 0.01 * scale.y));
        UIStyle.pushVar(UIStyle.VAR_SLIDER_HANDLE_SIZE, @(0.005 * scale.x, 0.08 * scale.y));
        UIStyle.pushVar(UIStyle.VAR_SLIDER_Z_INDEX, z_index);
        UIStyle.pushVar(UIStyle.VAR_SLIDER_ROTATE, rotZ);
        gui.slider(id, @(pos.x, pos.y), 0, 1, val) => val;
        UIStyle.popVar(4);
        UIStyle.popColor();
    }

    fun void render() {
        // tween between actual and target pos
        (now - _activate_time) / ANIM_TIME => float x;
        float t;
        float mark_t;
        if (_active) {
            easeOutBounce(x) => t;
            easeOutQuad(x) => mark_t;
        }
        else {
            easeInBack(x) => t;
            1 - Math.clampf(x * x, 0, 1) => mark_t;
        }

        start_pos + t * (target_pos - start_pos) => vec2 pos;

        mark_start_pos + mark_t * (mark_target_pos - mark_start_pos) => mark.pos;

        if (_powered_on) slider("zoomed_radio", @(_scale.x * 3, _scale.y * 1.5), pos, 4.1, true, true);

        UIStyle.pushVar(UIStyle.VAR_ICON_Z_INDEX, 4.0);
        UIStyle.pushVar(UIStyle.VAR_ICON_SIZE, @(1314./1314, 553./1314));
        UIStyle.pushVar(UIStyle.VAR_ICON_ROTATE, rot_spring.x);
        gui.icon(me.dir() + "../assets/ui/radio_box.png", pos);
        UIStyle.popVar(3);

        if (_active) {
            UIStyle.pushColor(UIStyle.COL_RECT, @(0, 0, 0, 0.6));
            UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(2, 2));
            UIStyle.pushVar(UIStyle.VAR_RECT_TRANSPARENT, true);
            UIStyle.pushVar(UIStyle.VAR_RECT_Z_INDEX, 3.5);
            gui.rect(@(0, 0));
            UIStyle.popVar(3);
            UIStyle.popColor();
        }
    }

    float curr_vel;
    fun void keyboardHandler() {
        0.015 => float accel;

        while (true) {
            GG.nextFrame() => now;
            GG.dt() => float dt;

            if (_active) {
                float dir;
                if (GWindow.key(GWindow.KEY_LEFT)) -1 => dir;
                if (GWindow.key(GWindow.KEY_RIGHT)) 1 => dir;

                Math.random2f(0, 1) * dir * dt * accel => float dv;
                dv +=> curr_vel;
                curr_vel +=> val;

                // hit edge
                if (val < 0 || val > 1) 0 => curr_vel;
            }
        }
    }

    fun void scale(vec2 s) {
        s => _scale;
    }
}

public class TitleRadioMechanic extends RadioMechanic {

    fun TitleRadioMechanic(ChuGUI gui) {
        gui @=> this.gui;
    }

    fun void activate() {
        if (_active) return;
        true => _active;
        now => _activate_time;
        @(0, 0) => start_pos;
        @(0, 0) => target_pos;

        for (int i; i < audio.size(); i++) {
            0.0 => audio[i].gain;
        }
        0.5 => radio_left.gain;
        0.5 => radio_right.gain;
        1 => radio_static.rate;
        1 => radio_hum.rate;

        spork ~ activateShred();
    }

    fun void activateShred() {
        second => now;
        waveform --> GG.scene();
        0 => radio_on.pos;
        1 => radio_on.rate;
        2 => radio_on.gain;
        true => _powered_on;
    }

    fun void deactivate() {
        if (!_active) return;
        0 => curr_vel;
        0 => _active;
        false => _powered_on;
        for (int i; i < audio.size(); i++) {
            0 => audio[i].gain;
        }
        .0 => radio_left.gain;
        .0 => radio_right.gain;
        0 => radio_on.gain;
        0 => radio_static.gain;
        0 => radio_hum.gain;

        waveform --< GG.scene();
    }

    fun void update() {
        if (_active && numOptions > 0) {
            updateSelection();
            updateAudio();
            map2waveform( samples, positions );
            waveform.positions( positions );
            render();
        }
    }

    fun void render() {
        if (_powered_on) slider("zoomed_radio", @(_scale.x * 2, _scale.y * 2), @(0, 0.25), 4.1, true, false);
        UIStyle.pushVar(UIStyle.VAR_ICON_Z_INDEX, -0.5);
        UIStyle.pushVar(UIStyle.VAR_ICON_SIZE, @(2, 2));
        gui.icon(me.dir() + "../assets/title/title_radio_box.png", _position);
        UIStyle.popVar(2);
    }
}

public class DeathRadioMechanic extends RadioMechanic {

    fun DeathRadioMechanic(ChuGUI gui) {
        gui @=> this.gui;
    }

    fun void activate() {
        if (_active) return;
        1 => _active;
        true => _powered_on;
        now => _activate_time;

        // Animate from bottom of screen
        @(0, -0.25 * GG.camera().viewSize()) => start_pos;
        @(0, -0.75) => target_pos;

        // Unmute audio
        for (int i; i < audio.size(); i++) {
            1.0 => audio[i].gain;
            1.0 => audio[i].rate;
        }
        0 => radio_on.pos;
        1 => radio_on.rate;
        1 => radio_on.gain;
        1 => radio_static.rate;
        1 => radio_hum.rate;
        1 => radio_left.gain;
        1 => radio_right.gain;
    }

    fun void deactivate() {
        if (!_active) return;
        0 => curr_vel;
        0 => _active;
        false => _powered_on;

        // Flip start/end to animate back down
        start_pos => vec2 tmp;
        target_pos => start_pos;
        tmp => target_pos;
        now => _activate_time;

        // Mute and stop all audio immediately
        for (int i; i < audio.size(); i++) {
            0 => audio[i].gain;
        }
        0 => radio_left.gain;
        0 => radio_right.gain;
        0 => radio_on.gain;
        0 => radio_static.gain;
        0 => radio_hum.gain;
    }

    fun void update() {
        GG.dt() => float dt;
        rot_spring.update(dt);

        if (_active && numOptions > 0) {
            updateSelection();
            updateAudio();
        }
        render();
    }

    fun void render() {
        // Tween between start and target pos (same as parent)
        (now - _activate_time) / ANIM_TIME => float x;
        float t;
        if (_active) {
            easeOutBounce(x) => t;
        } else {
            easeInBack(x) => t;
        }

        start_pos + t * (target_pos - start_pos) => vec2 pos;

        if (_powered_on) slider("zoomed_radio", @(_scale.x * 3, _scale.y * 1.5), pos, 4.75, true, true);

        UIStyle.pushVar(UIStyle.VAR_ICON_Z_INDEX, 4.6);
        UIStyle.pushVar(UIStyle.VAR_ICON_SIZE, @(1314./1314, 553./1314));
        UIStyle.pushVar(UIStyle.VAR_ICON_ROTATE, rot_spring.x);
        gui.icon(me.dir() + "../assets/ui/radio_box.png", pos);
        UIStyle.popVar(3);
    }
}

// // unit test
// if (1) {
//     ChuGUI gui --> GG.scene();
//     RadioMechanic radio(gui);

//     GG.camera().orthographic();
//     GG.camera().aspect(16./9);

//     // Initialize radio
//     radio.scale(@(0.525, 1.5));
//     radio.setPosition(@(-0.575, 0.4));
//     radio.setAudioBasePath(me.dir() + "assets/audio/");
//     radio.init();

//     radio.setOptions(["A", "B", "C"]);

//     while (1) {
//         GG.nextFrame() => now;
//         radio.update();

//         if (UI.button("activate")) radio.activate(); 
//         if (UI.button("deactivate")) radio.deactivate(); 
//         UI.slider("waveform zeno", radio.waveform_zeno, 0, 1);
//     }
// }
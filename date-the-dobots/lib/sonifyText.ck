/*
Mediabot: blit with fixed pitch, random harmonics
vaccuumbot: noise + bandpass filter
tsunderebot: sawtooth, sparse
sommellier bot: most musical, quantize to scale?

Improvement (if time)
- add panning / spatialization
*/

public class TextSonifier extends Chugraph {
    ADSR adsr(5::ms, 45::ms, 0, 0::ms) => outlet;
    adsr.gain(.1);
    UGen@ curr;

    SinOsc sin;
    SinOsc sin2; .5 => sin2.gain;

    PulseOsc pulse;
    SawOsc saw; .85 => saw.gain;
    Blit blit; 2.25 => blit.gain;

    // TODO remove if sticking with granular synth
    CNoise noise => BPF bpf(440, .5); 4 => bpf.gain;
    // noise.mode("pink");

    TriOsc lfo_tri => blackhole;
    LiSa lisa; 1 => lisa.gain;
    lisa.chan(0) => PoleZero blocker; .99 => blocker.blockZero;
    lisa.play( false );
    lisa.loop( false );
    lisa.maxVoices( 30 );
    me.dir() + "../assets/audio/vaccuum-cleaner.wav" => lisa.read;
    .001 => float GRAIN_POSITION_RANDOM; // grain position randomization
    (second / lisa.duration()) => lfo_tri.freq;

    UI_Float grain_len_ms(250);
    UI_Float grain_rate(1);
    float grain_rate_mod_period;


    // fire!
    fun void fireGrain(float grain_pos) {
        grain_len_ms.val()::ms => dur grain_len;
        grain_rate.val() => float rate;


        grain_pos + Math.random2f(0,GRAIN_POSITION_RANDOM) => float pos; // play pos
        // a grain
        if( lisa != null && pos >= 0 )
            spork ~ grain( pos * lisa.duration(), grain_len, grain_len * .5, grain_len * .5, 
            rate );
    }

    // grain sporkee
    fun void grain(dur pos, dur grainLen, dur rampUp, dur rampDown, float rate) {
        lisa.getVoice() => int voice;
        if (voice < 0) return;

        lisa.rate( voice, rate );
        lisa.playPos( voice, pos );
        lisa.rampUp( voice, rampUp );

        (grainLen - rampUp) => now; // wait

        lisa.rampDown( voice, rampDown );
        // rampDown => now; // wait
    }

    0 => static int Mode_None;
    1 => static int Mode_MediaBot;
    2 => static int Mode_VaccuumBot;
    3 => static int Mode_TsundereBot;
    4 => static int Mode_SommelierBot;
    5 => static int Mode_Count;

    [
      "None",
      "MediaBot",
      "VaccuumBot",
      "TsundereBot",
      "SommelierBot",
    ] @=> static string mode_names[];

    int _mode;

    // for tsundere bot
    int count;
    int every;

    fun TextSonifier(int mode) { this.mode(mode); }

    fun void mode(int mode) {
        // disconnect curr
        if (curr != null) curr =< adsr;
        sin2 =< adsr;
        mode => this._mode;
        blocker =< outlet;

        // default adsr settings
        5::ms => adsr.attackTime;
        45::ms => adsr.decayTime;

        if (mode == Mode_None) {
            // do nothing
        }
        else if (mode == Mode_MediaBot) {
            blit => adsr;
            45::ms => adsr.decayTime;
            blit @=> curr;
        }
        else if (mode == Mode_TsundereBot) {
            saw => adsr;
            150::ms => adsr.decayTime;
            saw @=> curr;
            Math.random2(3,6) => every;
        }
        else if (mode == Mode_VaccuumBot) {
            // bpf => adsr;
            // 100::ms => adsr.decayTime;
            // 150::ms => adsr.attackTime;
            // bpf @=> curr;
            Math.random2f(3.8, 5) => grain_rate_mod_period;
            blocker => outlet;
        }
        else if (mode == Mode_SommelierBot) {
            sin => adsr;
            sin2 => adsr;
            sin @=> curr;
            150::ms => adsr.decayTime;
            2 => every;
        }
        else <<< "unsupported mode", mode >>>;
    }

    [
        -5, -3, 0, 2, 4, 7, 9,
    ] @=> static int scale[];

    fun void speak() {
        // tsundere bot speaks every N chars
        if (_mode == Mode_TsundereBot) {
            if ((count++ % every) != 0) return;
            Math.random2(3,6) => every;

            // randomize pitch
            Std.mtof(Math.random2(63,65)) => saw.freq;
        }

        if (_mode == Mode_VaccuumBot) {
            // if (every == 0) Math.random2(3,5) => every;
            // if ((count++ % every) != 0) return;
            // Math.random2(3,5) => every;

            // Math.random2f(4000,7000) => bpf.freq;

            {
                // .5 + .5 * Math.sin(Math.two_pi * lisa_freq * (now/second)) => float t;
                .5 + .5 * lfo_tri.last() => float t;
                Math.remap(
                    Math.sin(1.7 * (now/second)), 
                    -1, 1, 50, 300
                ) => grain_len_ms.val;
                Math.remap(
                    Math.sin(grain_rate_mod_period * (now/second)), 
                    -1, 1, .9, 1.2 
                ) => grain_rate.val;
                // Math.random2f(.9, 1.1) => grain_rate.val;
                // Math.random2f(50, 250) => 
                fireGrain(t * .7);
            }
        }

        if (_mode == Mode_SommelierBot) {
            if ((count++ % every) != 0) return;

            Std.mtof(
                72 + scale[Math.random2(0, scale.size()-1)]
            ) => sin.freq;
            sin.freq() * 3 * 1.33 => sin2.freq;
        }

        // Std.mtof(text.text().charAt(char_count) - 32) => osc.freq;
        if (_mode == Mode_MediaBot) Math.random2(3,12) => blit.harmonics;
        adsr.keyOn();
    }

    // call after each sentence
    fun void reset() {
        0 => count;
    }

}

// GText text --> GG.scene();
// text.text("
// hello this is an example dialog string
// hello this is an example dialog string
// hello this is an example dialog string
// hello this is an example dialog string
// ");
// // text.text("123 456 789");
// .1 => text.size;
// text.characters(0);
// int char_count;

// TextSonifier son(TextSonifier.Mode_SommelierBot) => dac;

// fun int numSpaces(string s) {
//     int count;
//     for (int i; i < s.length(); ++i) {
//         if (s.charAt(i) == ' ') ++count;
//     }
//     return count;
// }

// // returns length of string minus spaces
// // because GTExt.characters() ignores spaces
// fun int charLength(string s) {
//     return s.length() - numSpaces(s);
// }

// UI_Int mode(son._mode);
// UI_Float attack_ms(son.adsr.attackTime()/ms);
// UI_Float decay_ms(son.adsr.decayTime()/ms);
// UI_Float bpf_q(son.bpf.Q());


// fun void g() {
//     while (1) {
//         GG.nextFrame() => now;
//         if (UI.slider("attack (ms)", attack_ms, 0, 100)) son.adsr.attackTime(attack_ms.val()::ms);
//         if (UI.slider("decay (ms)", decay_ms, 0, 100)) son.adsr.decayTime(decay_ms.val()::ms);

//         if (UI.listBox("mode", mode, TextSonifier.mode_names)) son.mode(mode.val());

//         if (UI.slider("Q", bpf_q, 0, 20)) bpf_q.val() => son.bpf.Q;

//         UI.slider("grain len", son.grain_len_ms, 1, 1000);
//         UI.slider("grain rate", son.grain_rate, .1, 10);

//         if (UI.button("reset")) {
//             son.reset();
//             0 => char_count;
//         }
//     }
// } spork ~ g();


// charLength(text.text()) => int len;


// while (1) {
//     text.characters(char_count + 1);
//     if (char_count < len) { 
//         son.speak();
//     }
//     ++char_count;
//     // <<< char_count >>>;
//     60::ms => now;
// }
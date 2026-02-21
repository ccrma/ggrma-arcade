
public class DeathMusic {
    SinOsc m => SinOsc osc => ADSR adsr(50::ms, 100::ms, .5, .5::second);
    .5 => adsr.gain;

    // TODO: try different static noise?
    SndBuf noise(me.dir() + "../assets/audio/radio-static.wav");
    1 => noise.loop; 0 => noise.rate;
    3 => noise.gain;

    0 => m.gain;
    2 => osc.sync;

    78 => float BPM;
    (60 / BPM)::second => dur qt_note;
    .5 * qt_note => dur eight_note;


    -50 => int REST;
    // @(midi_pitch, dur)
    [
        @(-5, 2), // c "i"
        @(-1, 1), // e see

        @(0, 5), // f  trees
        @(4, 1), // a  of

        @(7, 6), // c "green"

        @(REST, 2), // a
        @(9, 1), // a red
        @(9, 2), // a ros-
        @(9, 1), // a -es

        @(7, 6), // too

        @(REST, 2), // 
        @(5, 1), // i
        @(5, 2), // see
        @(5, 1), // them

        @(4, 6), // bloom

        @(REST, 2), // 
        @(2, 1), // for
        @(2, 2), // me
        @(2, 1), // and

        @(0, 4), // you
        @(0, 1), // and
        @(0, 1), // i

        @(0, 2), // think
        @(0, 3), // to
        @(0, 1), // my

        @(0, 6), // self

        @(REST, 4),
        @(0, 1), // what
        @(0, 1), // a

        @(-1, 2), // wond
        @(0, 2), // er
        @(2, 2), // ful

        @(4, 6), // world

        @(REST, 6),
    ] @=> vec2 score[];


    float target_freq;
    time last_note_on;
    fun void pitchSlew() {
        while (1) {
            osc.freq() + .04 * (target_freq - osc.freq()) => osc.freq;
            // longer notes get more vibrato
            (now - last_note_on) => dur time_since_last_note;
            if (time_since_last_note > eight_note) {
                4 * (time_since_last_note) / second => m.gain;
                Math.min(5, 4 * (time_since_last_note) / second) => m.freq;
            }
            256::samp => now;
        }
    } spork ~ pitchSlew();

    fun void stop() {
        adsr =< dac;
        noise =< dac;
        0 => noise.rate;
        0 => m.gain;
    }

    fun void play(float base_midi) {
        adsr => dac;
        noise => dac;
        1 => noise.rate;
        0 => noise.pos;

        // 1::second => now;
        for (auto note : score) {
            if (note.x == REST) adsr.keyOff();
            else {
                Std.mtof(base_midi + note.x) => target_freq;
                adsr.keyOn();
                now => last_note_on;
            }

            note.y::eight_note => now;
        }
        second => now;
        adsr =< dac;
        noise =< dac;
    }
}

DeathMusic music;
music.play(65);
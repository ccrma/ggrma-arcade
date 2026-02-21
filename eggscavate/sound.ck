public class Sound {
    // me.dir() + "sounds/explosion.wav" => string FILEPATH_EXPLOSION;
    me.dir() + "sounds/sfx/coin.wav" => string FILEPATH_COIN;
    // me.dir() + "sounds/select.wav" => string FILEPATH_SELECT;

    // Background Music
    me.dir() + "sounds/ChickenBPM.wav" => string FILEPATH_BGM;

    // Soil
    me.dir() + "sounds/soil1.wav" => string FILEPATH_SOIL1;
    me.dir() + "sounds/soil2.wav" => string FILEPATH_SOIL2;

    // Wood
    me.dir() + "sounds/wood1.wav" => string FILEPATH_WOOD1;
    me.dir() + "sounds/wood2.wav" => string FILEPATH_WOOD2;

    // Stone
    me.dir() + "sounds/stone1.wav" => string FILEPATH_STONE1;
    me.dir() + "sounds/stone2.wav" => string FILEPATH_STONE2;
    me.dir() + "sounds/stone3.wav" => string FILEPATH_STONE3;

    // Egg
    me.dir() + "sounds/egg.wav" => string FILEPATH_EGG;

    // Bawk (fall sounds)
    me.dir() + "sounds/sfx/bawk0.wav" => string FILEPATH_BAWK0;
    me.dir() + "sounds/sfx/bawk1.wav" => string FILEPATH_BAWK1;
    me.dir() + "sounds/sfx/bawk2.wav" => string FILEPATH_BAWK2;
    me.dir() + "sounds/sfx/bawk3.wav" => string FILEPATH_BAWK3;
    me.dir() + "sounds/sfx/bawk4.wav" => string FILEPATH_BAWK4;

    // insert coin
    me.dir() + "sounds/sfx/insertCoin.wav" => string FILEPATH_INSERT_COIN;

    me.dir() + "sounds/sfx/death.wav" => string FILEPATH_DEATH;

    me.dir() + "sounds/sfx/egg.wav" => string FILEPATH_EGG_UPGRADE;

    me.dir() + "sounds/sfx/spoiledEgg.wav" => string FILEPATH_SPOILED_EGG_UPGRADE;

    me.dir() + "sounds/sfx/powerup.wav" => string FILEPATH_POWERUP;

    me.dir() + "sounds/sfx/message.wav" => string FILEPATH_MESSAGE;

    me.dir() + "sounds/sfx/tool.wav" => string FILEPATH_TOOL_CHANGE;

    me.dir() + "sounds/sfx/wrongtool.wav" => string FILEPATH_WRONG_TOOL;

    float _bpm;
    time _beatStartTime;

    [
        new SndBuf, // new SndBuf(FILEPATH_EXPLOSION),
        new SndBuf(FILEPATH_COIN),
        new SndBuf, // new SndBuf(FILEPATH_SELECT),
        new SndBuf(FILEPATH_BGM),
        new SndBuf(FILEPATH_SOIL1),
        new SndBuf(FILEPATH_SOIL2),
        new SndBuf(FILEPATH_WOOD1),
        new SndBuf(FILEPATH_WOOD2),
        new SndBuf(FILEPATH_STONE1),
        new SndBuf(FILEPATH_STONE2),
        new SndBuf(FILEPATH_STONE3),
        new SndBuf(FILEPATH_EGG),

        // kunwoo kim collection
        new SndBuf(FILEPATH_BAWK0),
        new SndBuf(FILEPATH_BAWK1),
        new SndBuf(FILEPATH_BAWK2),
        new SndBuf(FILEPATH_BAWK3),
        new SndBuf(FILEPATH_BAWK4),
        new SndBuf(FILEPATH_INSERT_COIN),
        new SndBuf(FILEPATH_DEATH),
        new SndBuf(FILEPATH_EGG_UPGRADE),
        new SndBuf(FILEPATH_SPOILED_EGG_UPGRADE),
        new SndBuf(FILEPATH_POWERUP),
        new SndBuf(FILEPATH_MESSAGE),
        new SndBuf(FILEPATH_TOOL_CHANGE),
        new SndBuf(FILEPATH_WRONG_TOOL)
    ] @=> SndBuf bufs[];

    PoleZero pz => dac;
    .9 => pz.blockZero;

    fun Sound(float bpm) {
        bpm => _bpm;
        now => _beatStartTime;
    }

    // ------- Quantization Functions -------

    fun dur getBeatDuration() {
        return (60.0 / _bpm) * second;
    }

    fun float getCurrentBeatPosition() {
        (now - _beatStartTime) => dur elapsed;
        dur beatDur;
        getBeatDuration() => beatDur;
        
        return ((elapsed / beatDur) % 1.0);
    }

    fun dur getQuantizationDelay(int gridDivision) {
        (getBeatDuration() / gridDivision) => dur gridDur;
        (getCurrentBeatPosition() * gridDivision) => float gridPos;
        Math.ceil(gridPos) => float roundedGridPos;
        (roundedGridPos - gridPos) => float delayGrids;
        return (delayGrids * gridDur);
    }

    // Synchronize the beat clock to a reference time
    fun void syncBeat(time referenceTime) {
        referenceTime => _beatStartTime;
    }

    // ------- Play Functions -------

    fun void play(int ix) {
        play(ix, 1.0);
    }

    fun void play(int ix, float gain) {
        play(ix, gain, 1.0);
    }

    fun void play(int ix, float gain, float rate) {
        play(ix, gain, rate, 0);
    }

    fun void play(int ix, float gain, float rate, int loop) {
        play(ix, gain, rate, loop, 0);
    }

    // Quantized play function: gridDivision (0 = no quantization, 1 = beat, 2 = 8th, 4 = 16th)
    fun void play(int ix, float gain, float rate, int loop, int gridDivision) {
        play(ix, gain, rate, loop, gridDivision, 0::ms);
    }

    fun void play(int ix, float gain, float rate, int loop, int gridDivision, dur duration) {
        if (gridDivision > 0) {
            getQuantizationDelay(gridDivision) => dur delay;
            delay => now;
        }

        bufs[ix] => Gain g => pz;
        gain => g.gain;
        rate => bufs[ix].rate;
        loop => bufs[ix].loop;
        0 => bufs[ix].pos;

        // <<< "Playing sound:", ix >>>;
        
        if (duration != 0::ms) {
            duration => now;
        } else {
            bufs[ix].length() => now;
        }
    }

    // ------- Getters and Setters -------

    fun float bpm() { return _bpm; }
    fun void bpm(float bpm) { bpm => _bpm; }

    // ------- Enums -------

    0 => int SOUND_EXPLOSION;
    1 => int SOUND_COIN;
    2 => int SOUND_SELECT;
    3 => int SOUND_BGM;
    4 => int SOUND_SOIL1;
    5 => int SOUND_SOIL2;
    6 => int SOUND_WOOD1;
    7 => int SOUND_WOOD2;
    8 => int SOUND_STONE1;
    9 => int SOUND_STONE2;
    10 => int SOUND_STONE3;
    11 => int SOUND_EGG;

    12 => int SOUND_BAWK0;
    13 => int SOUND_BAWK1;
    14 => int SOUND_BAWK2;
    15 => int SOUND_BAWK3;
    16 => int SOUND_BAWK4;
    17 => int SOUND_INSERT_COIN;
    18 => int SOUND_DEATH;
    19 => int SOUND_EGG_UPGRADE;
    20 => int SOUND_SPOILED_EGG_UPGRADE;
    21 => int SOUND_POWERUP;
    22 => int SOUND_MESSAGE;
    23 => int SOUND_TOOL_CHANGE;
    24 => int SOUND_WRONG_TOOL;
}
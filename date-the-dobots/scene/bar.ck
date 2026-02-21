@import "scene.ck"

public class BarScene extends Scene {
    NPC stranger("", "");

    static GMesh@ light_mesh;
    if (light_mesh == null) {
        TextureLoadDesc desc;
        true => desc.flip_y;
        Texture.load( me.dir() + "../assets/bar/bar_light.png", desc ) @=> Texture light_tex;
        PlaneGeometry geo;
        FlatMaterial mat;
        mat.colorMap(light_tex);
        mat.transparent(true);
        new GMesh( geo, mat ) @=> light_mesh;
    }


    SndBuf light_buzz(me.dir() + "../assets/audio/light_buzz.wav") => dac;
    1 => light_buzz.loop;
    0 => light_buzz.rate;
    0.4 => float buzzBaseGain;

    SndBuf robot_steps(me.dir() + "../assets/audio/robot-steps.wav") => dac;
    1 => robot_steps.loop;
    0 => robot_steps.rate;

    SndBuf robot_noises(me.dir() + "../assets/audio/robot-noises.wav") => dac;
    1 => robot_noises.loop;
    0 => robot_noises.rate;

    false => int _stopAudio;

    fun BarScene() {
        me.dir() + "../assets/bar/background.png" => assetPath;
    }

    fun void init(Player @ player, Prompt prompts[]) {
        dm.dialog().leftMargin(3.5);
        dm.dialog().rightMargin(3.8);
        dm.setPlayer(player);

        dm.setNpc(stranger);

        dm.registerNpc("Daisun", me.dir() + "../assets/cleaner/cleaning-bot.png");
        dm.registerNpc("Daisun:Suspicious", me.dir() + "../assets/cleaner/cleaner-suspicious.png");
        dm.registerNpc("Daisun:Sad", me.dir() + "../assets/cleaner/cleaner-sad.png");
        dm.registerNpc("Daisun:Love", me.dir() + "../assets/cleaner/cleaner-love.png");
        dm.registerNpc("Daisun:Angry", me.dir() + "../assets/cleaner/cleaner-angry.png");
        dm.registerNpc("Daisun:Happy", me.dir() + "../assets/cleaner/cleaner-happy.png");

        dm.registerNpc("Dolbi", me.dir() + "../assets/media/media-bot.png");
        dm.registerNpc("Dolbi:Love", me.dir() + "../assets/media/media-love.png");
        dm.registerNpc("Dolbi:Suspicious", me.dir() + "../assets/media/media-suspicious.png");
        dm.registerNpc("Dolbi:Sad", me.dir() + "../assets/media/media-sad.png");
        dm.registerNpc("Dolbi:Happy", me.dir() + "../assets/media/media-happy.png");
        dm.registerNpc("Dolbi:Angry", me.dir() + "../assets/media/media-angry.png");

        dm.registerNpc("Doju", me.dir() + "../assets/sommelier/sommelier-bot.png");
        dm.registerNpc("Doju:Angry", me.dir() + "../assets/sommelier/sommelier-bot-angry.png");
        dm.registerNpc("Doju:Suspicious", me.dir() + "../assets/sommelier/sommelier-bot-suspicious.png");

        dm.registerNpc("Doshiba", me.dir() + "../assets/tsundere/tsundere-bot.png");
        dm.registerNpc("Doshiba:Love", me.dir() + "../assets/tsundere/tsundere-love.png");
        dm.registerNpc("Doshiba:Suspicious", me.dir() + "../assets/tsundere/tsundere-suspicious.png");
        dm.registerNpc("Doshiba:Happy", me.dir() + "../assets/tsundere/tsundere-happy.png");
        dm.registerNpc("Doshiba:Sad", me.dir() + "../assets/tsundere/tsundere-sad.png");
        dm.registerNpc("Doshiba:Angry", me.dir() + "../assets/tsundere/tsundere-angry.png");

        dm.startDialogue(prompts);

        // Start ambient audio (gains fade in)
        1 => light_buzz.rate;
        0.5 => robot_steps.rate;
        0.5 => robot_noises.rate;
        spork ~ fadeInAudio();

        light_mesh.sca(ChuGUI.NDCToWorldSize(@(2, 2)));
        light_mesh --> GG.scene();

        spork ~ lightFlicker();
    }

    fun void deinit() {
        stopAudio();
        if (light_mesh.parent() != null) light_mesh --< GG.scene();
    }

    fun void update(ChuGUI gui) {
        super.render(gui);
        stranger.update(gui);
        dm.update(gui);
    }

    fun void setLight(float alpha) {
        (light_mesh.mat() $ FlatMaterial).alpha(alpha);
        alpha / 0.8 * buzzBaseGain => light_buzz.gain;
    }
    
    fun void stopAudio() {
        true => _stopAudio;
        spork ~ fadeOutAudio();
    }

    fun void startAudio() {
        false => _stopAudio;
        spork ~ fadeInAudio();
        spork ~ lightFlicker();
    }

    fun void fadeOutAudio() {
        2.0 => float fadeDur;
        1 => float t;
        while (t > 0) {
            GG.nextFrame() => now;
            GG.dt() / fadeDur -=> t;
            if (t < 0) 0 => t;
            t * 0.4 => light_buzz.gain;
            t * 0.025 => robot_steps.gain;
            t * 0.03 => robot_noises.gain;
        }
    }

    fun void fadeInAudio() {
        2.0 => float fadeDur;
        0 => float t;
        while (t < 1) {
            GG.nextFrame() => now;
            GG.dt() / fadeDur +=> t;
            if (t > 1) 1 => t;
            t * 0.4 => light_buzz.gain;
            t * 0.025 => robot_steps.gain;
            t * 0.03 => robot_noises.gain;
        }
    }

    int _lightFlickerGen;
    fun void lightFlicker() {
        0.8 => float baseAlpha;
        0.1 => float flickerIntensity;

        ++_lightFlickerGen => int flickerGen;

        while (true) {
            if (flickerGen != _lightFlickerGen) return;
            // shutoff (~2% chance)
            if (Math.random2f(0, 1) < 0.02) {
                setLight(Math.random2f(0, 0.15));
                Math.random2f(0.05, 0.2)::second => now;
                if (maybe) {
                    setLight(baseAlpha);
                    0.05::second => now;
                    setLight(Math.random2f(0, 0.1));
                    Math.random2f(0.03, 0.08)::second => now;
                }
            }

            Math.random2f(-flickerIntensity, flickerIntensity) + baseAlpha => float flicker;
            setLight(flicker);
            Math.random2f(0.06, 0.15)::second => now;
        }
    }
}

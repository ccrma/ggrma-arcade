public class VolumeTracker extends Chugraph
{
    inlet => Gain g => OnePole env_follower => blackhole;
    inlet => g;
    3 => g.op;

    UI_Float env_low_cut(.08);
    UI_Float env_exp(.22);
    UI_Float env_pole_pos(.9998);

    env_pole_pos.val() => env_follower.pole;

    fun void ui() {
        if (UI.slider("Envelope Pole Position", env_pole_pos, .9, 1.0)) env_pole_pos.val() => env_follower.pole;
        UI.slider("Low Cut ", env_low_cut, 0, 1.0);
        UI.slider("Exponent", env_exp, 0, 1.0);
    }

    fun float vol() {
        return Math.max(
            0,
            Math.pow(env_follower.last(), env_exp.val()) - env_low_cut.val()
        );
    }
}
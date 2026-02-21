public class BGM_Playing
{
    SndBuf2 buffy => dac;
    me.dir() + "BGM_Mine_The_Way.wav" => buffy.read;
    buffy.loop(1);
    buffy.gain(0);
    
    fun void play()
    {
        buffy.pos(0);
        buffy.gain(0.75);
        buffy.rate(1);
    }
    
    fun void stop()
    {
        buffy.gain(0.0);
    }
}

public class BGM_Opening
{
    SndBuf2 buffy => JCRev r => dac;
    me.dir() + "BGM_Chicken_Or_Egg.wav" => buffy.read;
    buffy.loop(1);
    buffy.gain(0);

    r.mix(0.01);

    fun void play()
    {
        buffy.pos(0);
        buffy.gain(0.9);
        buffy.rate(1);
    }

    fun void stop()
    {
        buffy.gain(0.0);
    }
}
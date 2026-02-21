// This script contains what you need to play BGM
// "BGM_Playing.ck" uses SMUCK
// "BGM_Opening.ck" is a SndBuf wave file playback
// refer to the testing function for APIs.

@import {"BGM_Player.ck"}

BGM_Playing bgm_play;
BGM_Opening bgm_open;

<<<"Test">>>;

bgm_open.play();

fun void test()
{
    <<<"Playing Opening">>>;
    bgm_open.play();
    10::second => now;

    <<<"Stop Opening and Playing Play">>>;
    bgm_open.stop();
    bgm_play.play();
    5::second => now;

    bgm_play.stop();    
}
//test();

1::day => now;  
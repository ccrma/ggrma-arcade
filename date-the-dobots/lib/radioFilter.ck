
public class RadioFilter extends Chugraph
{
    inlet => LPF lpf(2200, 1) 
          => HPF hpf(1200, 3) 
          => Bitcrusher bc 
          => LPF bpf(4000, 1)
          => outlet;

    3 => hpf.gain;
    12 => bc.bits;
    12 => bc.downsample;
}
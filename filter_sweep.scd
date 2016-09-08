s.boot;

(
SynthDef(\filter_sweep, {arg freq0 = 40, freq1 = 4000, reso0 = 0.3, reso1 = 0.8, time = 2,
	gate = 1, out = 0;
	var freq = Phasor.kr(1, 0.1, freq0, freq1, freq0);
	var env = 1; // change with a proper env
	var noise = WhiteNoise.ar();
	var filter_out = RLPF.ar(noise, freq, reso0);
	// Debug, to see values outside
	SendTrig.kr(Impulse.kr(4), 0, freq);
	Out.ar(out, filter_out * env);
}).add;
)


~synth = Synth(\filter_sweep, []);

c = Bus.control;

~synth.map(\freq0, c);

{Out.kr(c, MouseY.kr(200, 4000))}.play;

o = OSCFunc({ |msg| msg.postln }, '/tr', s.addr);
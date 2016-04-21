s.boot;

// For debugging tips, search the help for Debugging tips

(
// TODO:
// do we need to scale the Mix back
// add modulation parameters
//
SynthDef("rum", {arg osc_freq = 440, osc_pitch = 0, osc_wavetype = 0, osc_width = 0.5,
	amp_gain = 0.5, amp_velo = 1, amp_a = 0.01, amp_d = 0.3, amp_s = 0.5, amp_r = 1,
	subosc_gain = 0,
	filter_cutoff = 3000, filter_reso = 0.5, filter_drive = 0,
	gate = 1, out = 0;


	// osc_wave = 0 is saw wave, and 1 is pulse wave, values in between mix both waves
	var env = Env.adsr(amp_a, amp_d, amp_s, amp_r).kr(2, gate, mul: amp_gain);
	var saw = Saw.ar(osc_freq, 1 - osc_wavetype);
	var square = Pulse.ar(osc_freq, osc_width, osc_wavetype);
	var sub = SinOsc.ar(osc_freq / 2);
	var wave_mix = Mix([saw, square, sub]);
	var filter_out = RLPF.ar(wave_mix, filter_cutoff, filter_reso);
	// Debug, to see values outside
	//SendTrig.kr(Impulse.kr(4), 0, filter_cutoff);
	Out.ar(out, filter_out * env);
}).add;
)

r = Synth("rum")
r.set(\osc_freq, 69.midicps);
r.release

c = Bus.control;
r.map(\filter_cutoff, c);
c.scope;
s.scope;
c.set(0);

{Out.kr(c, MouseY.kr(10, 4000))}.play;
r.get(\filter_cutoff, {arg val; val.postln})

// Debug, to see the values outside
o = OSCFunc({arg msg; msg.postln}, '/tr', s.addr);
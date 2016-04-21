s.boot;

(
SynthDef("rum", {arg osc_freq = 440, osc_pitch = 0, osc_wavetype = 0, osc_width = 0.5,
	amp_gain = 0.5, amp_velo = 1, amp_a = 0.01, amp_d = 0.3, amp_s = 0.5, amp_r = 1,
	gate = 1, out = 0;

	// osc_wave = 0 is saw wave, and 1 is pulse wave, values in between mix both waves
	var env = Env.adsr(amp_a, amp_d, amp_s, amp_r).kr(2, gate, mul: amp_gain); // still need to modify with midi_velo and the parameter amp_velo
	var saw = Saw.ar(osc_freq, 1 - osc_wavetype);
	var square = Pulse.ar(osc_freq, osc_width, osc_wavetype);
	var wave_mix = Mix([saw, square]);
	Out.ar(out, wave_mix * env);
}).add;
)

rum = Synth("rum")
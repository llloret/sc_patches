s.boot;

// For debugging tips, search the help for Debugging tips

(
// TODO:
// do we need to scale the Mix back
// add modulation parameters
// to mix the saw and square waves (perhaps it is better to use the LinSelectX UGen)
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
	var sub = SinOsc.ar(osc_freq / 2, mul: subosc_gain);
	var wave_mix = Mix([saw, square, sub]) / 3;
	var filter_out = RLPF.ar(wave_mix, filter_cutoff, filter_reso);
	// Debug, to see values outside
	SendTrig.kr(Impulse.kr(4), 0, osc_wavetype);
	Out.ar(out, filter_out * env);
}).add;
)

c = Bus.control;
d = Bus.control;
e = Bus.control;

// MIDI Handling
(
~midinotes = Array.newClear(128);
MIDIIn.connectAll;
MIDIFunc.trace(true);
MIDIFunc.noteOn({arg val, num, chan, src;
	var synth = Synth(\rum, [\osc_freq, num.midicps, \subosc_gain, 0.0]);
	~midinotes[num] = synth;
	~midinotes[num].map(\osc_wavetype, c);
	~midinotes[num].map(\subosc_gain, d);
	~midinotes[num].map(\filter_cutoff, e);
});

MIDIFunc.noteOff({arg val, num, chan, src;
	~midinotes[num].release;
	~midinotes[num] = nil;
});

MIDIFunc.cc({arg val, num, chan, src;
	if (num == 28, {c.set(val/127.0)});
	if (num == 29, {d.set(val/127.0)});
	if (num == 74, {e.set(val*10)});
});
)
// MIDI test
MIDIIn.doNoteOnAction(89, 89, 89, 69);
MIDIIn.doNoteOffAction(89, 89, 89, 69);
//
~midinotes[91].postln

// Standalone stuff

c.scope;
s.scope;

{Out.kr(c, MouseY.kr(0, 1))}.play;

{Out.kr(c, EnvGen.kr(Env.adsr(1, 1), LFPulse.kr(0.2)))}.play;

{Out.kr(c, MouseY.kr(100, 10000))}.play;
{Out.kr(d, MouseX.kr(0, 1))}.play;

// Debug, to see the values outside
o = OSCFunc({arg msg; msg.postln}, '/tr', s.addr);

~synth = Synth(\rum, [\osc_freq, 60.midicps, \subosc_gain, 0.0]);
~synth.map(\osc_freq, c);
~synth.map(\osc_wavetype, d);
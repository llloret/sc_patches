s.boot;

(

// On the filters do not allow freq values next to 0
SynthDef(\fx_delay, {arg max_phase = 2, phase = 0.5, feedback = 0.7, cross_feedback = 0, enable_lpf = 0, feedback_lpf_cutoff = 5000, enable_hpf = 0, feedback_hpf_cutoff = 1000, in, out;
	var inL, inR, fbinL, fbinR, totalInL, totalInR, delayedL, delayedR, lpfOutL, lpfOutR, hpfOutL, hpfOutR;
	# inL, inR = In.ar(in, 2);
	# fbinL, fbinR = LocalIn.ar(2);

	totalInL = inL + (fbinL * feedback * (1 - cross_feedback)) + (fbinR * feedback * cross_feedback);
	totalInR = inR + (fbinR * feedback * (1 - cross_feedback)) + (fbinL * feedback * cross_feedback);
	# delayedL, delayedR = DelayL.ar([totalInL, totalInR], max_phase, phase);

	lpfOutL = Select.ar(if (enable_lpf, 0,  1), [LPF.ar(delayedL, feedback_lpf_cutoff), delayedL]);
	lpfOutR = Select.ar(if (enable_lpf, 0,  1), [LPF.ar(delayedR, feedback_lpf_cutoff), delayedR]);
	hpfOutL = Select.ar(if (enable_hpf, 0,  1), [HPF.ar(lpfOutL, feedback_hpf_cutoff), lpfOutL]);
	hpfOutR = Select.ar(if (enable_hpf, 0,  1), [HPF.ar(lpfOutR, feedback_hpf_cutoff), lpfOutR]);

	LocalOut.ar([hpfOutL, hpfOutR]);
	Out.ar(out, [hpfOutL, hpfOutR]);
}).add;
)

~fxbus = Bus.audio(s, 2);
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
{PlayBuf.ar(1, b)}.play(outbus: ~fxbus);

~synth = Synth(\fx_delay, [\in, 4, \out, 0]);



c = Bus.control;

~synth.map(\freq0, c);

{Out.kr(c, MouseY.kr(200, 4000))}.play;

o = OSCFunc({ |msg| msg.postln }, '/tr', s.addr);

CombN

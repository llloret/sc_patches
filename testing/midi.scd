// osmid m2o testing
(
OSCFunc.trace;
MIDIClient.init;
MIDIIn.connectAll;
g = MIDIOut(1);
)
g.noteOn(2, 70, 80)




// Initialize MIDI
MIDIClient.init

// Show sources and destinations
MIDIClient.sources
MIDIClient.destinations

// Connect all MIDI inputs
MIDIIn.connectAll

// ... or connect just one
MIDIIn.connect(0)
MIDIIn.disconnect(0)

// Register a MIDI listener
MIDIFunc.noteOn({arg ...args; "ON:  ".post; args.postln}); // match any noteOn
MIDIFunc.noteOff({arg ...args; "OFF: ".post; args.postln}); // match any noteOff
MIDIFunc.program({arg ...args; "PRG: ".post; args.postln}); // Program change
MIDIFunc.cc({arg ...args; args.postln}); // match any CC
MIDIFunc.sysex({arg ...args; args.postln});
MIDIFunc.sysrt({arg ...args; "sysrt".postln; args.postln});
MIDIFunc.midiClock({arg ...args; "clock".postln; args.postln});
MIDIFunc.start({arg ...args; "start".postln;args.postln});

// I have 2 output devices, the Microsoft GS synth (device 0) and LoopBe1 (a virtual loopback MID port) (device 1)
m = MIDIOut(0)
g = MIDIOut(1)

// What you would expect is that if I send to m (MIDIOut(0)), nothing is shown on the MIDIFunc. But if I send to g (MIDIOut(1)), since that is a loopback device, I would expect to see input on the MIDIFunc.
m.noteOn(1, 60, 60)
g.noteOn(2, 70, 80)


MIDIClient.sources.do(_.dump);
MIDIFunc.trace(true);


// Test issue #1046
(
MIDIClient.init;

// note, edit to specify a real device in your system!
m = MIDIOut(1);

Tdef(\o, {
    loop {
        m.control(0, 7, 128.rand.postln);
        0.25.wait;
    }
}).play;

MIDIIn.connectAll;
MIDIFunc.trace(true);
)


// Test SysEx output, issue #1200, with the MicroKontrol
(
MIDIClient.init;
MIDIIn.connect(0);
g = MIDIOut(1);
MIDIFunc.trace(false);
// Transmit Scene Change Request
g.sysex(Int8Array[
	16rf0,
	16r42,
	16r40,
	16r6e,
	16r00,
	16rf8, // test some realtime messages in the middle of the stream
	16rf8,
	16rfa,
	16r1f,
	16r14,
	16r05,
	16rf7]);
g.midiClock();
g.start();
)


(
// Play different sounds in external synth(
MIDIClient.init;

// edit to specify a real device in your system!
m = MIDIOut(1);

~channel = 0;
~prog = 0;

Tdef(\o, {
    loop {
        m.program(~channel, ~prog);
        0.1.wait;
		m.noteOn(0, 60);
		1.wait;
		m.noteOff(0, 60);
		m.noteOn(0, 72);
		1.wait;
		m.noteOff(0, 72);
		m.noteOn(0, 84);
		1.wait;
		m.noteOff(0, 84);
		~prog = ~prog + 1;
		if (~prog >= 127, { ~prog = 0; ~channel = ~channel + 1; })
    }
}).play;

MIDIIn.connectAll;
MIDIFunc.trace(true);
)

(
MIDIClient.init;
MIDIIn.connectAll;
MIDIFunc.trace(true);

~channel = 0;
~prog = 0;

// edit to specify a real device in your system!
m = MIDIOut(1);

Routine({
    loop {
		var cond = Condition.new;
		"Here".postln;
        m.program(~channel, ~prog);
		Pseq([
			Pbind(
				\type, \midi,
				\midicmd, \noteOn,
				\midiout, m,
				\chan, 0,
				\midinote, Pseq([60, 72, 84, [60, 64, 67]], 1),
				\dur, Pn(2)
			),
			Rest(2),
			(play: {cond.unhang})
		]).play;

		cond.hang;
		~prog = ~prog + 1;
		if (~prog >= 127, { ~prog = 0; ~channel = ~channel + 1; })
    }
}
).play;
)


(
var vr = 0;
Routine({
	loop {
	vr = vr + 1;
	vr.postln;
	1.yield;
	}
}
).play;
)

b=(play: {123.postln;})
b.play

a = Pseq([1, 2, 3, 4, (play: {"Hi".postln;})], 2).trace.play


(
k = Pbind(
	    \degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
	    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).asStream;    // remember, you have to make a stream out of the pattern before using it
)

(
k = Pbind(
	\degree, Pseq([6, 7, 8, 6, (play: {"hi".postln;}) 6, 7], 1),
	\dur, Pn(2)
).asStream;
)

k.next(())

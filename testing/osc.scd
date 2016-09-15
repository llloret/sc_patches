// osmid o2m testing
(
OSCFunc.trace;
MIDIClient.init;
MIDIIn.connectAll;

// Register a MIDI listener
MIDIFunc.noteOn({arg ...args; "ON:  ".post; args.postln}); // match any noteOn
MIDIFunc.noteOff({arg ...args; "OFF: ".post; args.postln}); // match any noteOff
MIDIFunc.program({arg ...args; "PRG: ".post; args.postln}); // Program change
MIDIFunc.cc({arg ...args; args.postln}); // match any CC
MIDIFunc.sysex({arg ...args; args.postln});
MIDIFunc.sysrt({arg ...args; "sysrt".postln; args.postln});
MIDIFunc.midiClock({arg ...args; "clock".postln; args.postln});
MIDIFunc.start({arg ...args; "start".postln;args.postln});
MIDIFunc.trace;
)

(
b = NetAddr.new("127.0.0.1", 57200);    // create the NetAddr
b.sendMsg("/hello/raw", 0x91, 0x13, 0x12);
)
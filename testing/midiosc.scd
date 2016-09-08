n = NetAddr("127.0.0.1", NetAddr.langPort); // local machine

OSCFunc({|msg, time, addr, recvPort| "match".postln; msg.postln;}, nil, n);
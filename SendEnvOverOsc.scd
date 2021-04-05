s.boot;
s.plotTree
ServerOptions.devices; // all devices

(
Server.default.options.inDevice_("Fireface UC Mac (23557042)");
Server.default.options.outDevice_("Fireface UC Mac (23557042)");
s.boot;
)


///////////////////////////////////////////////////
// This demo sends the envelope signal of a kickdrum via OSC on the port defined in "SendEnvOcerOsc.scd"
// ToDo:
// * Fix Bug: After restarting the pattern, no OSC messages are send any more. A restart of the synthDef is needed
///////////////////////////////////////////////////
(
//var oscBridge=OSCBridge.new;
//oscBridge.init;

~oscbridge = OSCBridge.new("127.0.0.1", 10000);

//Kick-Drum:

SynthDef.new(\kick, {
	arg freqA=1000, freqB=50, freqC=10, freqDur1=0.01, freqDur2=0.2, freqC1=1, freqC2=(-1),
	att=0.01, rel=1, c1=1, c2=(-12), amp=0.3, pan=0, out=0, oscGate=1;
	var sig, env, freqSweep, oscAddress="/kick";
	freqSweep = Env([freqA, freqB, freqC], [freqDur1, freqDur2],[freqC1, freqC2]).ar;
	env = Env([0, 1, 0], [att, rel], [c1, c2]).kr(doneAction: 2);
	~oscbridge.sendSignal(oscAddress, env, oscGate);
	sig = SinOsc.ar(freqSweep, pi/2);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

//Group:
g = Group.new; // the group is needed to take care, that just the last object (of thy polyphone sound) is sending it's signal

//Pattern:

Pbind(
	\instrument, \kick,
	\dur, 2 * Pseq([0.4, 0.1, 0.2], inf),
	\amp, 0.8,
	\freqA, 700,
	\att, 0.035,
	\rel, 1,
	\group, g,
	\finish, {
		s.makeBundle(s.latency - 0.02, { g.set(\oscGate, 0) }); // by setting the oscGates of all objects in the group to 0, just the new next new added object will send its signal.
	}
).play;
)

x = Synth.new(\kick, [\amp, 1, \freqA, 400, \freqDur2, 0.5]);
(
var oscBridge=OSCBridge.new;
oscBridge.init;

//Kick-Drum:

SynthDef.new(\kick, {
	arg freqA=1000, freqB=50, freqC=10, freqDur1=0.01, freqDur2=0.2, freqC1=1, freqC2=(-1),
	att=0.01, rel=1, c1=1, c2=(-12), amp=0.3, pan=0, out=0, oscGate=1;
	var sig, env, freqSweep, oscAddress="/kick";
	freqSweep = Env([freqA, freqB, freqC], [freqDur1, freqDur2],[freqC1, freqC2]).ar;
	env = Env([0, 1, 0], [att, rel], [c1, c2]).kr(doneAction: 2);
	oscBridge.sendSignal(oscAddress, env, oscGate);
	sig = SinOsc.ar(freqSweep, pi/2);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

//Group:
g = Group.new;

//Pattern:

Pbind(
	\instrument, \kick,
	\dur, 2 * Pseq([1, 0.25, 0.75], inf),
	\amp, 0.8,
	\freqA, 700,
	\att, 0.035,
	\rel, 1,
	\group, g,
	\finish, {
		s.makeBundle(s.latency - 0.01, { g.set(\oscGate, 0) });
	}
).play;
)
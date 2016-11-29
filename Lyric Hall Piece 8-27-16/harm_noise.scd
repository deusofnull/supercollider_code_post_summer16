s.boot;

(
SynthDef(\harmWave, {
	arg pitch = rrand(200,1000), resonzTime=8,
	atk = 0.01, rel=8, curve=4, amp=1;
	var noise, resonance, env;

	env = EnvGen.kr(Env.perc(
		atk,
		rel, level:1, curve: curve), doneAction:2);

	noise = PinkNoise.ar(1);
	resonance = Resonz.ar(
		in: noise,
		freq: [pitch, pitch/2],
		bwr: XLine.kr(0.5, 0.001, resonzTime)
	);
	resonance = resonance * env;
	resonance = Pan2.ar(resonance, 0, amp);
	Out.ar(0, resonance);
}).add;
)

Synth.new(\harmWave);

(
Pdef(\harmPat1,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pseq([100,150,100,125],inf),
		\dur, Pseq([0.25, 0.25,0.25,0.25] *05 ,inf),
		\resonzTime, 1.75,
		\rel, Pkey(\dur),
		\amp, 4.5,
		\curve, 6,
	)
).stop;
)

(
Pdef(\harm_slow,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pxrand([100,200,400,125, 500, 250, 700, 50],inf),
		\dur, Pxrand([0.25, 0.5,0.5,0.25, 0.125, 0.125, 1,3,5, 1.25]  ,inf),
		\resonzTime, 15,
		\rel, Pkey(\dur),
		\amp, 1.5,
		\curve, 6,
	)
).stop;
)
s.scope;

(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
s.boot;

// TODO:  add features to harmWave
// - better envelope controls
// - Pan2 with amplitude  and env
// - control over [pitch, pitch/pitchDiv]
(
SynthDef(\harmWave, {
	arg pitch = rrand(200,1000), resonzTime=8,
	atk = 0.01, rel=8, curve=4;
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
	Out.ar(0, resonance);
}).add;
)

Synth.new(\harmWave);


Pdef(\harmPat1,).stop;
(
Pdef(\harmPat1,
	Pbind(
		\instrument, \harmWave,
		//\pitch, Pseq([700, 350, 500, 250, 100],inf),
		\pitch, Pxrand([700, 350, 500, 250, 100],inf),
		\dur, Pseq([0.25,0.35, 0.15] ,inf),
		\resonzTime, 100,
		\rel, Pkey(\dur),
		\curve, 6,
	)
).play;
)
Pdef(\harClap,).stop;
(
Pdef(\harClap,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pxrand([1200, 1100,1000,900,1300] / 0.5,inf),
		//\pitch, Pseq([1200, 1100,1000,900,1300],inf),
		\dur, Pxrand([0.1, 0.08, 0.05, 0.25, 0.15] / 0.125,inf),
		//\dur, Pseq([0.1, 0.08, 0.05] / 0.25,inf),
		\resonzTime, 200,
		\rel, Pkey(\dur),
		\curve, -1,
	)
).play;
)

(
Pdef(\harClap2,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pseq([200, 200, 200, 125, 350] * 2,inf),
		//\pitch, Pseq([1200, 1100,1000,900,1300],inf),
		\dur, Pseq([0.5,0.25,0.25,1, 2] / 1.5 ,inf),
		//\dur, Pseq([0.1, 0.08, 0.05] / 0.25,inf),
		\resonzTime, Pseq([
			Pseq([0.25], 16),
			Pseq([0.5], 16),
			Pseq([1.0], 16)], inf).trace,
		\rel, Pkey(\dur),
		\curve, -1,
	)
).play;
)




(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
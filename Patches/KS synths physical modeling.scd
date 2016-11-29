(
// let's create a synthdef using Karplus-Strong
// we use Comb delay to create the delay line that creates the tone
SynthDef(\ks_guitar, { arg note, pan, rand, delayTime, noiseType=1;
	var x, y, env;
	env = Env.new(#[1, 1, 0],#[2, 0.001]);
	// A simple exciter x, with some randomness.
	x = Decay.ar(
		in:Impulse.ar(
			freq:0,
			phase:0,
			mul:rand),
		decayTime:0.1+rand,
		mul:WhiteNoise.ar);
	// Note that delayTime is controlling the pitch here. The delay time is reciprocal to the pitch. // 1/100th of a sec is 100Hz, 1/400th of a sec is 400Hz.
 	x = CombL.ar(
		in:x,
		maxdelaytime:0.05,
		delaytime:note.reciprocal,
		decaytime:delayTime,
		mul:EnvGen.ar(env, doneAction:2));
	x = Pan2.ar(x, pan);
	Out.ar(0, LeakDC.ar(x));
}).store;
)

(
{
	20.do({
		Synth(\ks_guitar,
			[
				\note, 220+(400.rand),
				\pan, 1.0.rand2,
				\rand, 0.1+0.1.rand,
				\delayTime, 2+1.0.rand
			]
		);
	  (1.0.rand + 0.5).wait;
	});
}.fork
)

(
SynthDef(\KS_pink, {
	arg midiPitch=69, delayDecay = 1.0;
	var burstEnv, atk = 0, dec= 0.001;
	var signalOut, delayTime;

	// this controls pitch:  input pitch and 1 octave higher aswell
	delayTime = [midiPitch, midiPitch + 12].midicps.reciprocal;
	burstEnv = EnvGen.kr(Env.perc(atk, dec));
	signalOut = PinkNoise.ar(burstEnv); // pinknoise exciter
	signalOut = CombL.ar( // CombL for pitch made by delayTime
		in: signalOut,
		maxdelaytime: delayTime,
		delaytime: delayTime,
		decaytime: delayDecay,
		add: signalOut
	);
	DetectSilence.ar(signalOut, doneAction:2);
	Out.ar(0, signalOut);
	}
).store;
)
Synth(\KS_pink);
TempoClock.default.tempo = 120/60;
(
Pdef(\pattern2,
	Pbind(
		\instrument, \KS_pink, // using our sine synthdef
		\midiPitch, Pseq([25, 77, 43, 55,63,63 ], inf), // freq arg
		\dur, Pseq([0.5, 0.5, 0.5, 0.25,0.1,0.1,2], inf),  // dur arg
		\rand, Prand([0.2, 0.15, 0.15, 0.11], inf),  // dur arg
		\pan, 2.0.rand-1,
		\delayTime, 2+1.0.rand;  // envdur arg
		)
).play;
)
s.reboot;

(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)


// Formally known as Ascending Overdriven Bass
// In truth, this is a lagged varsaw synth played with 3 different patterns

~scaleLenShort = Pfunc({ exprand(2,12).round;}).asStream; // how far up in scale to go
~scaleLen = Pfunc({ exprand(2,24).round;}).asStream; // 2 octaves long

~scaleLen.next();

TempoClock.default.tempo = 1;
TempoClock.default.tempo = 1.15;
TempoClock.default.tempo = 5;

TempoClock.default.tempo = 300; // v fun to go fast
TempoClock.default.tempo = 15; // v fun to go fast

TempoClock.default.tempo = 0.25; // gets heavy AF when you go slow
TempoClock.default.tempo = 120/60; // in bpm format


// as a Pmono, monophonic synth with one voice wavering into  each newly genearted sound
(Pdef(\ascBassMonoSlider,
	Pmono(
		\varSawLagged,
		\scale, Scale.harmonicMinor,
		\degree, Pseq([Pseries(0, Prand([1,2,3],inf), {~scaleLen.next()})] ,inf),
		\dur, Pwrand(
			[0.125,0.25,0.5,1,5],
			[1, 2, 2, 0.5, 0.25].normalizeSum,
			inf),
		\detune, Pexprand(0.75, 1.25,inf),
		\slideTime, Pseries(0.17, 0.01, inf),
		\preamp, 1000,
		\lpffreq, Pexprand(550,750,inf),
		\amp, 0.15,
	).trace;
).play.quant_(5);)

// as a Pbind, events driven by this one are more atomic, separate sound instances
(Pdef(\ascBassJazzyTriads,
	Pbind(
		\instrument, \varSawLagged,
		\dur, Pexprand(0.5, 1.5, inf), // fast and random
		//\degree, Pseq([Pseries(0, Prand([1,6,12],inf), {~scaleLenShort.next()})] ,inf),
		\scale, Scale.harmonicMinor,
		\degree, Pxrand([
			[0,3,5],
			[0,4,5],
			[0,3,6],
			[0,4,6],
		],inf).trace,
		\ctranspose, Pexprand(1,8.0,inf).round.trace,
		\detune, Pexprand(0.95, 1.05,inf).trace,
		\preamp, 10,
		\lpffreq, Pexprand(550,750,inf),
		\amp, 0.1,
)
).play.quant_(2.5);)


(
Pdef(\ascBassKick).stop;
Pdef(\ascBassKick2).stop;
);

(
Pdef(\ascBassKick,
	Pbind(
	\instrument, \varSawLagged,
	\dur, 0.25,
	\ctranspose, Pseq([
			Pseq([
				Pseq([-3],4),
				Pseq([-2],4),
			],4),
			Pseq([
				Pseq([-1],4),
				Pseq([2],4),
			],3),
		],inf),
	\midinote, Pseq(
	[
		Pseq([27], 15),
		Pseq([23], 1)
	], inf),
	\decay, 0.7,
	\sus, 0.2,
	\rel, 0.3,
	\amp, 0.1,
	)
).play.quant_(0.25 * 16);
Pdef(\ascBassKick2,
	Pbind(
		\instrument, \varSawLagged,
		\dur, Pseq([0.25, 0.125, 0.25],inf),
		\ctranspose, -2,
		\midinote, Pseq(
			[
				Pseq([
					Pseq([24], 15),
					Pseq([23], 1)
				], 1),
				Pseq([
					Pseq([27], 15),
					Pseq([23], 1)
				], 1),
		], inf),
		\decay, 0.7,
		\sus, 0.2,
		\rel, 0.3,
		\amp, 0.1,
	)
).play.quant_(0.25 * 16);
)

(Pdef(\ascBassKickScaled,
	Pbind(
		\instrument, \varSawLagged,
		\dur, 0.5,
		\scale, Scale.lydian,
		\ctranspose, Pexprand(1,10,inf).round * Pxrand([1, -1], inf),
		\degree, Pseq(
			[
				Pseq([
					Pseq([[5,3]], 7),
					Pseq([[0,-5]], 1)
				], 1),
				Pseq([
					Pseq([[3,1]], 7),
					Pseq([[0,-5]], 1)
				], 1),
		], inf),
		\atk, 0.05,
		/*\decay, 0.1,
		\sus, 0.02,
		\rel, 0.1,*/
		\amp, 0.3,
	)
).stop.quant_(0.5 * 7);)

(Pdef(\ascBassKickScaledMonophonic,
	Pmono(
		\varSawLagged,
		\dur, 0.25,
		\scale, Scale.lydian,
		\ctranspose, Pexprand(1,10,inf).round * Pxrand([1, -1], inf),
		\degree, Pseq(
			[
				Pseq([
					Pseq([[5,3]], 7),
					Pseq([[0,-5]], 1)
				], 1),
				Pseq([
					Pseq([[3,1]], 7),
					Pseq([[0,-5]], 1)
				], 1),
		], inf),
		\atk, 0.05,
		/*\decay, 0.1,
		\sus, 0.02,
		\rel, 0.1,*/
		\amp, 0.8,
	)
).play.quant_(0.5 * 7);)


// THINGS LEFT TO DO
/*

  - Could be cool to synce up ~kick, ~p1 and ~p2.
  - Work on Kick more... it's boring rn
  - p2 is really  beautiful, p1 is scary and wrong,
    - either widen that gap and make them complimentary or make them more alike
*/

(
SynthDef(\varSawLagged, {
	arg freq=220, gate=1, amp=0.5, slideTime=0.17, lpffreq=550, width=0.15,
	detune=1.005, preamp=4, atk=0.01, decay=0.3, sus=0.4, rel=0.1 ;
	var sig, env= Env.adsr(atk, decay, sus, rel);
	freq = Lag.kr(freq, slideTime);
	sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: 2);
	sig = LPF.ar(sig, lpffreq);
	Out.ar(0, sig ! 2);
}).add;)

Synth(\varSawLagged);

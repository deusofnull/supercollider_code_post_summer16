s.boot;
(
SynthDef(\pmDistortLPF, {
	arg atk=0, sus=0, rel=3, c1=1, c2=(-1),
	carfreq = 220, modfreq = 100, modindex = 1,
	lpfhz=4000, lpfmix=0, pan=0, amp=1, out=0;
	var carrier, modulator, env,
	conversion= 2pi/(s.sampleRate), lpf;

	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:2);
	modulator = SinOscFB.ar(modfreq);
	carrier = SinOscFB.ar(carfreq, ((modfreq*modindex)*conversion*modulator),0.25);
	// inA = clean, inB = LPF
	carrier = XFade2.ar(carrier, LPF.ar(carrier, lpfhz),lpfmix);

	carrier = Pan2.ar(carrier, pan, amp);

	Out.ar(out, carrier);
	}
).add;
)
s.quit;
Synth(\pmDistortLPF);

(
~pmDistort.stop;
~pmDistort = Routine {

	loop{

		2.do{
			Synth(\pmDistortLPF, [
				\atk, 0.25,
				\sus, {rrand(0.75, 4)},
				\rel, 0.5 ,
				\modindex,{rrand(200,300)},  // turn higher for more modulation EX 100 - 300
				//\carfreq, {[25,50,100,200,400,500,600,800, rrand(25,800)].choose / 0.5},  // VERY SCARY SOUNDING
				\carfreq,  // More Musical
				{(Scale.harmonicMinor.degrees+[55,57,59,62].choose).choose.midicps
					* [0.25,0.5,1,1.5].choose
				} / 1 ,
				//\modfreq, {rrand(50,600)},// VERY SCARY SOUNDING
				\modfreq,{
					(Scale.harmonicMinor.degrees+55).choose.midicps
					* [0.25,0.5,1,1.5].choose
				},
				\lpfmix, 1.25,
				\pan, {rrand(-0.5,0.5)},
				\amp, 0.43,
			]);
			//slow
			rrand(1,1.5).yield;

			//rrand(0.25,0.5).yield;

			"~pmDistort".postln;
		}
	}
}.play;
)


(
~scaleLenRout = Pfunc({ exprand(2,24).round;}).asStream; // 2 octaves long
~ascendingPMdistorted.stop;
~ascendingPMdistorted = Routine {
	loop {
		1.do{
			Synth(\pmDistortLPF, [
				\atk, {rrand(0.8,2.4)},
				\sus, {rrand(1.75, 4)},
				\rel, {rrand(0.5, 1)},
				\modindex,{rrand(80,120)},
				\carfreq, {
				(Scale.harmonicMinor.degrees+[55].choose).choose.midicps
					* [0.25,0.5,1,1.5].choose
				} / 1,
				\modfreq, {rrand(50,250)},// VERY SCARY SOUNDING
				\degree, {~scaleLenRout.next();},
				\lpfhz, 2000,
				\lpfmix, 1.25,
				\pan, {rrand(-0.5,0.5)},
				\amp, 0.52,
			]);
		};
		"~ascendingPMdistorted".postln;
		2.5.wait;
	}
}.play;
)

// for pattern control

(
SynthDef(\pmDistortLPFPatternCtrl, {
	arg atk=0, sus=0, rel=3, c1=1, c2=(-1),
	freq = 220, slideTime= 0.0, modfreq = 100, modindex = 1,
	lpfhz=4000, lpfmix=0, pan=0, amp=1, out=0;
	var carrier, modulator, env,
	conversion= 2pi/(s.sampleRate), lpf;

	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:2);
	modulator = SinOscFB.ar(modfreq);
	freq = Lag.kr(freq, slideTime);
	carrier = SinOscFB.ar(freq, ((modfreq*modindex)*conversion*modulator),0.25);
	// inA = clean, inB = LPF
	carrier = XFade2.ar(carrier, LPF.ar(carrier, lpfhz),lpfmix);

	carrier = Pan2.ar(carrier, pan, amp);

	Out.ar(out, carrier);
	}
).add;
)


Pdef(\meanderPMdistorted).stop;
(
~scaleLenPats = Pfunc({ exprand(2,6).round;}).asStream; //
Pdef(\meanderPMdistorted,
	Pbind(
		\instrument, \pmDistortLPFPatternCtrl,
		\dur, 0.5,     // .125 is safe
		\atk, Pexprand(0.15,0.3,inf),
		\sus, Pexprand(0.15,0.8,inf),
		\rel, Pexprand(0.15,0.3,inf),
		\modindex, Pexprand(50,350,inf),
		\modfreq, Pexprand(75,250,inf),
		//\ctranspose, Pxrand([-10,-5,-1,1,3,5,10],inf), // octave transposition
		\ctranspose, 0,
		\scale, Scale.lydian,
		\degree, Pseq([Pseries(0, Prand([-3,-2,-1,0,1,2,3],inf), {~scaleLenPats.next()})] ,inf),
		\detune, Pexprand(0.75, 1.25,inf),
		\slideTime, Pseries(0.17, 3, inf),
		\preamp, 1000,
		\lpffreq, Pexprand(550,750,inf),
		\amp, 0.4,
	)
).play)

Pdef(\Musical).stop;

(Pdef(\Musical,
	Pbind(
		\instrument, \pmDistortLPFPatternCtrl,
		\dur, 0.75,
		\atk, 0.25,
		\sus, 1,
		\rel, 0.25,
		\modindex, Pexprand(90,95,inf),
		\modfreq, Pexprand(75,100,inf),
		\ctranspose, Pseq([-10,-5,-1,1,3,5],inf), // octave transposition
		//\ctranspose, Pseq([1],inf),
		\scale, Scale.lydian,
		/*\degree, Pseq([Pseries(0, Prand([-3,-2,-1,0,1,2,3],inf), {~~scaleLenPats.next()})] ,inf).trace,*/
		\degree, Pseq([
			Pseq([0,4,2,5],1),
			Pseq([0,3,7,4,2,4,0,5],1),
		],inf).trace,
		\detune, Pexprand(0.75, 1.25,inf),
		\slideTime, Pseries(0.17, 0.01, inf),
		\preamp, 1000,
		\lpffreq, Pexprand(550,750,inf),
		\amp, 0.2,
	)
).play)
//=================================================================================================================
//============================================== THIS IS THE BEST ONE =============================================
//=================================================================================================================

(
SynthDef(\pmDistortLPFMonophonic, {
	arg freq = 220, slideTime= 0.0, modfreq = 100, modindex = 1,
	lpfhz=4000, lpfmix=0, pan=0, amp=1, out=0;
	var carrier, modulator, env,
	conversion= 2pi/(s.sampleRate), lpf;
	modfreq = Lag.kr(modfreq, slideTime);
	freq = Lag.kr(freq, slideTime);

	modulator = SinOscFB.ar(modfreq);
	carrier = SinOscFB.ar(freq, ((modfreq*modindex)*conversion*modulator),0.25);

	// inA = clean, inB = LPF
	carrier = XFade2.ar(carrier, LPF.ar(carrier, lpfhz),lpfmix);

	carrier = Pan2.ar(carrier, pan, amp);

	Out.ar(out, carrier);
	}
).add;
)

Pdef(\monophonicPhaseModeLPF).stop;
(
~scaleLenPatsMonophonic = Pfunc({ exprand(2,12).round;}).asStream; // how long this seq is
~scaleLenPatsMonophonic.next();
Pdef(\monophonicPhaseModeLPF,
	Pmono(
		\pmDistortLPFMonophonic,
		\dur, Pexprand(0.25,0.5,inf),
		\atk, Pexprand(0.15,0.3,inf),
		\sus, Pexprand(0.15,0.3,inf),
		\rel, Pexprand(0.15,0.3,inf),
		\modindex, Pexprand(150,160,inf), // default 15,50 - increase over time, 100, 250 is sick
		\modfreq, Pexprand(250,650,inf),   //default 50,500  - crazy 250,1000
		\ctranspose, Pxrand([-10,-5,-1,1,3,5,10],inf), // octave transposition
		//\ctranspose, -5,     //default
		\scale, Scale.harmonicMajor,
		/*\degree, Pseq([Pseries(0, Prand([-3,-2,-1,0,1,2,3],inf),
			{~scaleLenPatsMonophonic.next()})] ,inf), //default degree*/
		\degree, Pseq([Pseries(0, Prand([0,1,2,3],inf),
			{~scaleLenPatsMonophonic.next()})] ,inf), //alternative degree
		\slideTime, Pexprand(2.5,10,inf),
		\lpffreq, Pexprand(550,750,inf),
		\amp, 0.33,
	)
).play)
//=================================================================================================================
//=================================================================================================================
//=================================================================================================================

s.boot;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
// FM + PM distorted synths

s.boot;


// these are the original synths.  They are technically an incorrect implimentation of FM and PM using SinOscFB
(
SynthDef(\fmDistort, {
	arg atk=0, sus=0, rel=3, c1=1, c2=(-1),
	carfreq = 220, modfreq = 100, modindex = 1,
	distort = 1, pan=0, amp=1, out=0;
	var carrier, modulator, env;

	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:2);
	modulator = SinOscFB.ar(modfreq);
	carrier = SinOscFB.ar(carfreq + (modindex*modfreq*modulator), distort, 0.25);

	carrier = Pan2.ar(carrier, pan, amp);

	Out.ar(out, carrier);
	}
).add;
)


(
SynthDef(\pmDistort, {
	arg atk=0, sus=0, rel=3, c1=1, c2=(-1),
	carfreq = 220, modfreq = 100, modindex = 1,
	distort = 1, pan=0, amp=1, out=0;
	var carrier, modulator, env,
	conversion= 2pi/(s.sampleRate);

	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:2);
	modulator = SinOscFB.ar(modfreq);
	carrier = SinOscFB.ar(carfreq, ( (modfreq*modindex)*conversion*modulator),0.25);

	carrier = Pan2.ar(carrier, pan, amp);

	Out.ar(out, carrier);
	}
).add;
)

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



(
~pmDistortSeq.stop;
~pmDistortSeq = Routine {

	loop{

		2.do{
			Synth(\pmDistortLPF, [
				\modindex,{rrand(80,120)},
				\carfreq, {[25,50,100,200,400,500,600,800, rrand(25,800)].choose.postln},
				\modfreq, {rrand(300,450)},
				\lpfmix, 1.25,
				\pan, {rrand(-1,1)},
				\atk, 0.25,
				\sus, 1,
				\rel, 0.5 ,
				\amp, 0.25,
			]);
			rrand(0.5,1).yield;
		}
	}
}.play;
)

(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
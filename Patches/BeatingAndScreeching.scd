
(SynthDef.new(\delayBuf,{
	arg atk=0, sus=0, rel=3, c1=1, c2=(-1),
	buf=0, rate=1, startPos=0,
	maxDelay=0.2, delayTime=0.1, decayTime=1, delayMix = 0,
	pan=0, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:2);
	sig = PlayBuf.ar(1, buf, rate*BufRateScale.kr(buf), startPos:startPos);
	sig = XFade2.ar(sig,CombN.ar(sig, maxDelay, delayTime, decayTime), delayMix);
	sig = sig * env;
	sig = Limiter.ar(sig, 0.85);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(SynthDef.new(\noise_fm_vco, {
    arg atk=0.1, sus=0.5, rel=2, c1=1, c2=(-1),
	noise_freq=250, noise_add=150, noise_mul = 300,
	amp = 0.75, pan=0 ;
    var noise, mod_vco, car_vco, env;

		env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:2);

    noise = LFNoise1.ar(noise_freq, noise_mul, noise_add);

    mod_vco = SinOsc.ar(noise, 0, noise * 8.0, noise);

    car_vco = SinOsc.ar(mod_vco, 0, 0.2);

	car_vco = car_vco * env;

	car_vco = Pan2.ar(car_vco, pan, amp);

    Out.ar(0, car_vco!2);
}
).add)




(
~beating.stop;
~beating = Routine {
	loop {
		Synth(\delayBuf,
			[
				\buf, b[\metal][[1].choose],
				\maxDelay, 0.5,
				\delayTime, rrand(0.009,0.03),
				\rate, rrand(0.3,0.5),
				\pan, rrand(-1,1),
				\delayMix, 1,
				\amp, 0.8,

			]
		);
		rrand(0.05,0.3).yield;
	}

}.stop;)

(
~beater.stop;
~beater = Routine {
	loop {
		Synth(\delayBuf,
			[
				\buf, b[\metal][[0].choose],
				\maxDelay, 0.5,
				\delayTime, rrand(0.009,0.03),
				\rate, rrand(0.6,2.3),
				\pan, rrand(-1,1),
				\delayMix, 1,
				\amp, 0.5,

			]
		);
		0.15.yield;
	}

}.stop;)



(
~screeching.stop;
~screeching = Routine {

	loop{
		1.do{

			Synth(\noise_fm_vco, [
				\noise_freq, rrand(60, 300),
				\atk, 0.5,
				\sus, rrand(1,5),
				\rel, 0.5,
				\noise_mul, rrand(150, 500),
				\noise_add, [rrand(300,900), rrand(10, 60)],
				\amp, 0.4,
			]);
		};
		rrand(1.5,3.5).wait;
	}
}.play;
)

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
		rrand(0.1,0.3).yield;
	}

}.play;)
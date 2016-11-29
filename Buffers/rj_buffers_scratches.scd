s.boot;
(
b = Dictionary.new;
PathName("/home/wilach/nullsounds/samples/RJ_Samples_Sorted/Sorted").entries.do{
	arg subfolder;
	b.add(subfolder.folderName.asSymbol ->
		Array.fill(
			subfolder.entries.size,
			{
				arg i;
				Buffer.read(s, subfolder.entries[i].fullPath);
			}
		)
	)
};
)
b.keys;

b[\scratches][0].play; // canvas full
b[\scratches][0].numFrames;
b[\scratches][0].plot;

b[\scratches][1].play; // carpet clip

b[\scratches][2].play; // chips eating

b[\scratches][3].play; // drawing

b[\scratches][4].play; // pencil

b[\scratches][5].play; // tearing paper


// Oscilating Resonz BWR + Freq
(SynthDef.new(\resonzBender1,{
	arg atk=0, sus=0, rel=3, c1=1, c2=(-1),
	buf=0, rate=1, startPos=0, freq=440, rq=1, bpfmix=0,
	pan=0, amp=1, limit=0.7, lookahead = 0.1, out=0,
	freqRandHz=3, freqRandMul = 1000,
	bwrOscHz=5, bwrOscMul = 0.1;
	var sig, env, freqRand, bwrOsc;
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:2);
	sig = PlayBuf.ar(1, buf, rate*BufRateScale.kr(buf), startPos:startPos);

	freqRand = LFNoise2.ar(freqRandHz,freqRandMul);
	bwrOsc = SinOsc.ar(bwrOscHz, 0, bwrOscMul);
	sig = Resonz.ar(sig, freqRand, bwrOsc);

	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	sig = Limiter.ar(sig, limit, lookahead);
	Out.ar(out, sig);
}).add;
)


(
Synth.head(s, \resonzBender1,
	[
		\buf, b[\scratches][5],
		\atk, 0.1,
		\sus, 8,
		\rel, 0.25,
		\rate, 1,
		\freqRandHz, 2,
		\freqRandMul, 1000,
		\bwrOscHz, 50,
		\bwrOscMul, 1,
		\pan, 0,
		\out, 0,
		\amp, 0.5,
	]
);
)

(
{ BufCombC.ar(b.bufnum, Decay.ar((
Synth.head(s, \resonzBender1,
	[
		\buf, b[\scratches][5],
		\atk, 0.1,
		\sus, 8,
		\rel, 0.25,
		\rate, 1,
		\freqRandHz, 2,
		\freqRandMul, 1000,
		\bwrOscHz, 50,
		\bwrOscMul, 1,
		\pan, 0,
		\out, 0,
		\amp, 0.5,
	]
)
), 0.2, WhiteNoise.ar), 0.2, 3) }.play;
)
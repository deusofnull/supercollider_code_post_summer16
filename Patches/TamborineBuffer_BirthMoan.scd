(~routine= Routine {
	loop{
		"beat".postln;
		64.do{
			Synth.head(s, \bpfbuf,
				[
					\buf, [\tamborine][[0,1,2].choose],
					\atk, rrand(1,2.5),
					\sus, rrand(1,3),
					\rel, rrand(5, 10),
					\freq,(Scale.lydian.degrees+68).choose.midicps * [0.25,0.5,1,1.5].choose,
					\rq, 1/200, // denomonator goes up, more bpf water sounds
					\rate, rrand(-4.0, 3.0),
					\bpfmix, 1,
					\pan, rrand(-0.5,0.5),
					\out, 0,
					\amp, 0.2,
				]
			);
		};
		6.wait;
	}
}.play)
~routine.stop;

(
64.do{
	Synth.head(s, \bpfbuf,
		[
			\buf, [\tamborine][[2].choose],
			\atk, rrand(0.1,0.9),
			\rel, rrand(2.5, 7.50),
			\freq,(Scale.major.degrees+60).choose.midicps * [0.25,0.5,1].choose,
			\rq, 1/50, // denomonator goes up, more bpf water sounds
			\rate, rrand(-2.0, 8.0),
			\bpfmix, 1,
			\pan, rrand(-0.5,0.5),
			\out, 0,
			\amp, 2,
		]
	);
}
)
~reverbSynth = Synth.tail(s, \reverbFX, [\in, ~reverbBus, \reverbTime, 3.2]);



(SynthDef.new(\bpfbuf,{
	arg atk=0, sus=0, rel=3, c1=1, c2=(-1),
	buf=0, rate=1, startPos=0, freq=440, rq=1, bpfmix=0,
	pan=0, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:2);
	sig = PlayBuf.ar(1, buf, rate*BufRateScale.kr(buf), startPos:startPos);
	// XFade2 is a equal balance crossfade Ugen for
	// smooth panning between filtered and clean signal
	// bpfmix: -1 = first signal, 1 = second signal, 0 = crossfade
	sig = XFade2.ar(sig, BPF.ar(sig, freq, rq, 1/rq.sqrt), bpfmix);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)
// Dictionary for buffer organization
(
b = Dictionary.new;
PathName("/home/wilach/nullsounds/samples/sc_buffers").entries.do{
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
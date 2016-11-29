// Start up functions are below
s.boot;
s.quit;
(
~fluttering.stop;
~fluttering= Routine {

	~flutter = {
		16.do{
			Synth.head(s, \bpfbuf,
				[
					\buf, b[\tamborine][[0,1,2].choose],
					\atk, rrand(0.1,0.5),
					\sus, rrand(1,3),
					\rel, rrand(2, 4),
					\freq,{(Scale.minor.degrees+60).choose.midicps * [0.25,0.5,1,1.5].choose},
					\rq, 1/50, // denomonator goes up, more bpf water sounds
					\rate, rrand(-4.0, 2.1),
					//\rate, {rrand(0.1, 0.75)},
					\bpfmix, 1.25,
					\pan, rrand(-0.5,0.5),
					\out, 0,
					\amp, 20,
				]
			);
		};
	};

	loop{
		~flutter.play;
		"~flutter1".postln;
		1.5.wait;
		~flutter.play;
		"~flutter2".postln;
		rrand(3,6).wait;
		//rrand(1.5,3).wait;
	}
}.play)


(
~glitterSlap.stop;
~glitterSlap = Routine {

	loop {

		12.do{
			Synth(\bpfbuf,
				[
					\buf, b[\tamborine][[0,1,2].choose],
					\atk, {exprand(0.125,0.25)},
					\sus, rrand(2.5, 5.0),
					\rel, rrand(0.5, 1.0),
					//\freq, rrand(100,7000),
					// TRY THIS
					\freq, {((Scale.lydian.degrees).choose+exprand(40,70)).midicps * [1,2].choose},
					\rq, rrand(1/50, 1/200),
					\rate, rrand(0.1, 4.0),
					\bpfmix, 0.5,
					\pan, rrand(-1,1),
					\out, 0,
					\amp, 0.4,
				]
			);
		};
		// start slow
		rrand(2.5,5.00).wait;
		// medium
		//rrand(1.5,2.70).wait;

		//fast
		//rrand(0.5,1.50).wait;
		"~glitterSlap".postln;
	}
}.play;
)
~glitterSlap.stop;


// Single Glitter


(
36.do{
	Synth(\bpfbuf,
		[
			\buf, b[\tamborine][[0,1,2].choose],
			\sus, rrand(2.5, 5.0),
			\rel, rrand(2.5, 5.0),
			//\freq, rrand(3500,7000),
			// TRY THIS
			\freq, (Scale.lydian.degrees+89).choose.midicps * [1,2].choose,
			\rq, 1/50,
			\rate, rrand(1.5, 3.0),
			\bpfmix, 1.25,
			\pan, rrand(-1,1),
			\out, 0,
			\amp, 0.1,
		]
	);
}
)







/// ==================== Start up functions


(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
// buffer playback synthdef with BPF

(SynthDef.new(\bpfbuf,{
	arg atk=0, sus=0, rel=3, c1=1, c2=(-1),
	buf=0, rate=1, startPos=0, freq=440, rq=1, bpfmix=0, loop=0, doneAction=2,
	pan=0, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:doneAction);
	sig = PlayBuf.ar(1, buf, rate*BufRateScale.kr(buf), loop:loop, startPos:startPos);
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
s.boot;

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
b.keys;


b[\humanVoices][0].play;  // plays Mike Laughing
b[\tamborine][2].play;
b[\metal][2].play;
b[\rattle_metal][3].play;
b[\rattle_metal][1].play;
b[\rattle_metal][1].duration;


(Pdef(\metal_beat,
	Pbind(
		\instrument, \bpfbuf,
		\buf, b[\rattle_metal][[0,1,2,3].choose],
		\rate, Pexprand(0.1,0.75,inf),
		\dur, b[\rattle_metal][1].duration * Pkey(\rate),
		\pan, 0,
		//\pan, Pexprand(-1,1,inf),
		\amp, 1.5,
	)
).play);

s.reboot;





(~fluttering= Routine {
	loop{
		"beat".postln;
		64.do{
			Synth.head(s, \bpfbuf,
				[
					\buf, [\tamborine][[0,1,2].choose],
					\atk, rrand(1,2.5),
					\sus, rrand(1,3),
					\rel, rrand(5, 10),
					\freq,(Scale.lydian.degrees+69).choose.midicps * [0.25,0.5,1,1.5].choose,
					\rq, 1/200, // denomonator goes up, more bpf water sounds
					\rate, rrand(-4.0, 2.1),
					\bpfmix, 1,
					\pan, rrand(-0.5,0.5),
					\out, 0,
					\amp, 2,
				]
			);
		};
		rrand(3,6).wait;
	}
}.play)
~fluttering.stop;

(
64.do{
	Synth.head(s, \bpfbuf,
		[
			\buf, [\tamborine][[0,1,2].choose],
			\atk, rrand(0.1,0.9),
			\rel, rrand(2.5, 7.50),
			\freq,(Scale.lydian.degrees+69).choose.midicps * [0.25,0.5,1].choose,
			\rq, 1/200, // denomonator goes up, more bpf water sounds
			\rate, rrand(-2.0, 2.0),
			\bpfmix, 1,
			\pan, rrand(-0.5,0.5),
			\out, 0,
			\amp, 2,
		]
	);
}
)
~reverbSynth = Synth.tail(s, \reverbFX, [\in, ~reverbBus, \reverbTime, 3.2]);

(
36.do{
	Synth(\bpfbuf,
		[
			\buf, [\tamborine][[0,1,2].choose],
			\sus, rrand(2.5, 5.0),
			\rel, rrand(2.5, 5.0),
			\freq, rrand(100,7000),
			// TRY THIS
			// freq, (Scale.lydian.degrees+69).choose.midicps * [1,2].choose,
			\rq, 1/50,
			\rate, rrand(-8.0, 8.0),
			\bpfmix, 0.5,
			\pan, rrand(-1,1),
			\out, 0,
			\amp, 1,
		]
	);
}
)
	
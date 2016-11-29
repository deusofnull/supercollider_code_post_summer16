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
b[\metal][0].play;

(~metalRoutine= Routine{
	for(0,1, {
		arg i;
		b[\metal][i].play;
		1.wait;});
	/*loop{
		"hi".postln;
		1.yield;
	}*/

}.play;);


(~shaking= Routine{
	loop{
		"shaking".postln;
		b[\metal][1].play;
		1.yield;
	}

}.play;);
~shaking.stop;

(~beattom= Routine{
	loop{
		"beattom".postln;
		b[\metal][0].play;
		1.yield;
	}

}.play;);
~beattom.stop;


// now with bpf buff synth


(~shakingBPFSynth= Routine{
	loop{
		Synth.head(s, \bpfbuf,
			[
				\buf, b[\metal][1];,
				\atk, rrand(1,2.5),
				\sus, rrand(1,3),
				\rel, rrand(5, 10),
				//\freq,(Scale.lydian.degrees+69).choose.midicps * [0.25,0.5,1,1.5].choose,
				//\rq, 1/200, // denomonator goes up, more bpf water sounds
				//\rate, rrand(-4.0, 0.1),
				\rate, 1,
				\bpfmix, 1,
				\pan, rrand(-0.5,0.5),
				\out, 0,
				\amp, 5,
			]
		);
		3.wait;
	}

}.play;);
~shakingBPFSynth.stop;

(
Pdef(\shakingBPF,
	Pbind(
		\instrument, \bpfbuf,
		\dur, Pseq([1.5], inf) * 1.25 ,
		\buf, b[\metal][1],
		\atk, 0.5,
		\sus, 0.5,
		\rel, 0.5,
		\degree, Pseq([0,3,0,5], inf),
		\scale, Scale.minor,
		\root, -6,
		\rate, Pexprand(0.49, 0.5,inf).trace,
		\bpfmix, 1,
		\pan, rrand(-0.5,0.5),
		\out, 0,
		\amp, 5,
	)
).play;
);

(
Pdef(\signGong1,
	Pbind(
		\instrument, \bpfbuf,
		\dur, Pseq([0.25,0.5,0.5,0.25,],inf) / 1.25,
		\buf, b[\metal][3],
		\degree, Pseq([0,3,0,5], inf),
		\scale, Scale.lydian,
		\root, -6,
		\rq, Pxrand([1/4,], inf).trace, // denomonator goes up, more bpf water sounds
		//\rate, rrand(-4.0, 0.1),
		//\freq, Pseq([200,300,400,500,600,700,800],inf).trace,
		\rate, 1,
		\bpfmix, 1,
		\pan, rrand(-0.5,0.5),
		\out, 0,
		\amp, 1.5,
	)
).play;
);
(
Pdef(\signGongHeartBeat,
	Pbind(
		\instrument, \bpfbuf,
		\dur, (Pexprand(3.5,4.3,inf) / 3).trace,
		\buf, b[\metal][3],
		\degree, Pseq([0,7], inf),
		\scale, Scale.lydian,
		\root, -4,
		\rq, Pxrand([1/4,], inf), // denomonator goes up, more bpf water sounds
		//\rate, rrand(-4.0, 0.1),
		//\freq, Pseq([200,300,400,500,600,700,800],inf).trace,
		\rate, 1/8,
		\bpfmix, 1,
		\pan, Pseq([-1,1],inf),
		\out, 0,
		\amp, 1.5,
	)
).play;
);

(
Pdef(\signGong1,
	Pbind(
		\instrument, \bpfbuf,
		\dur, Pseq([0.25,0.5,0.5,0.25,],inf) /  0.5,
		\buf, b[\metal][0],
		\degree, Pseq([0,3,0,5], inf),
		\scale, Scale.lydian,
		\root, -8,
		\rq, Pxrand([1/8,], inf).trace, // denomonator goes up, more bpf water sounds
		//\rate, rrand(-4.0, 0.1),
		//\freq, Pseq([200,300,400,500,600,700,800],inf).trace,
		\rate, 1,
		\bpfmix, 1,
		\pan, rrand(-0.5,0.5),
		\out, 0,
		\amp, 1.5,
	)
).play;
);

s.quit;


//}
//)
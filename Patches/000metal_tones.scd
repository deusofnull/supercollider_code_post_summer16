// Start up functions are below

(
~metalScratching.stop;
~metalScratching = Routine {
	loop {
		6.do{ // 1.do at start, increase up to 6
			Synth.head(s, \bpfbuf,
				[
					\buf, b[\rattle_metal][[1].choose],   // 1 = beat, 0,2,3 = scratching
					\c1, -3,
					\atk, rrand(0.125,0.25),
					\sus, rrand(0.4,0.6),
					\rel, rrand(0.25, 0.5),
					\c2, -6,
					\freq, {rrand(500,7000)}, // default setting
					\rq, 1/150, // increase for more wetness
					//\freq, rrand(20,50), // for low scary water sounds
					//\rate, {rrand(1.610, 2.0)},
					\rate, {rrand(0.10, 1.15)},
					\pan, rrand(-0.5,0.5),
					\out, 0,
					\amp, 0.25,
				]
			);
		};
		rrand(0.4,0.7).wait;
		//rrand(0.4,0.7).wait;
		"~metalScratching".postln;
		};
}.play;
)
(
~guitarSample.stop;
~guitarSample = Routine{
	loop{
		3.do{
			Synth.head(s, \bpfbuf,
				[
					\buf, b[\guitar][[2].choose],  // 0 = input jack  1 = low rumble   2 = riff
					\c1, -3,
					\atk, rrand(1,2.5),
					\sus, rrand(4,10),
					\rel, rrand(1, 3),
					\c2, -6,
					\freq, {exprand(1000,50)}, // default setting
					\rq, {exprand(1/50,1/500)}, // increase for more wetness
					//\freq, rrand(20,50), // for low scary water sounds
					\rate, {exprand(0.4,2.0)},
					//\rate, 1,
					\pan, rrand(-0.5,0.5),
					\out, 0,
					\amp, 0.35,
				]
			);
		};
		2.5.wait;
		"~guitarSample".postln;
	};
}.play;
)

(
~construction.stop;
~construction = Routine{
	loop{
		3.do{
			Synth.head(s, \bpfbuf,
				[
					\buf, b[\construction_screech][[3].choose],  // 0 = low -> high 1 = high -> low   2 =  high
					\c1, -3,
					\atk, rrand(1,2.5),
					\sus, rrand(4,10),
					\rel, rrand(1, 3),
					\c2, -6,
					//\freq, {exprand(1000,50)}, // default setting
					\rq, {exprand(1/250,1/500)}, // increase for more wetness
					\freq, rrand(20,50), // for low scary water sounds
					\rate, {exprand(0.4, 0.5)},
					//\rate, 1,
					\pan, rrand(-0.5,0.5),
					\out, 0,
					\amp, 0.25,
				]
			);
		};
		1.5.wait;
		"~~construction".postln;
	};
}.play;
)

(
~construction2.stop;
~construction2 = Routine{
	loop{
		3.do{
			Synth.head(s, \bpfbuf,
				[
					\buf, b[\construction_screech][[0,1].choose],// 0 = low -> high 1 = high -> low   2 =  high
					\c1, -3,
					\atk, rrand(1,2.5),
					\sus, rrand(4,10),
					\rel, rrand(1, 3),
					\c2, -6,
					//\freq, {exprand(1000,50)}, // default setting
					\rq, {exprand(1/250,1/500)}, // increase for more wetness
					\freq, rrand(20,50), // for low scary water sounds
					\rate, {exprand(0.4,2.0)},
					//\rate, 1,
					\pan, rrand(-0.5,0.5),
					\out, 0,
					\amp, 0.75,
				]
			);
		};
		1.5.wait;
		"~~construction2".postln;
	};
}.play;
)

b[\rattle_metal][0].bufnum;
b[\rattle_metal][0].play;

b[\guitar][0].play;
b[\guitar][1].play;

b[\guitar][2].play;


b[\construction_screech][0].play;
b[\construction_screech][1].play;
b[\construction_screech][2].play;

b[\radio_distortion][2].play; // why does she keep going
b[\radio_distortion][3].play; // thank you so much for being here

b[\radio_distortion][1].play; // big chunk


Pdef(\radio_beat).stop;
(Pdef(\radio_beat,
	Pbind(
		\instrument, \bpfbuf,

		\buf, b[\radio_distortion][0],
		\c1, -3,
		\atk, rrand(0.1,0.25),
		\sus, rrand(4,10),
		\rel, rrand(1, 3),
		\c2, -6,
		\freq, {exprand(1000,50)}, // default setting
		//\freq, rrand(20,50), // for low scary water sounds
		\rq, {exprand(1/5,1/10)}, // increase for more wetness
		//\rate, {exprand(0.9,1.1)},
		\rate, 0.8,
		\dur, b[\radio_distortion][0].duration * Pkey(\rate),
		\pan, rrand(-0.5,0.5),
		\out, 0,
		\amp, 1.5,
	);
).play;
)




// =============================================== Start up functions
s.reboot;
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
	pan=0, amp=1, out=0, panOsc=0.1;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:doneAction);
	sig = PlayBuf.ar(1, buf, rate*BufRateScale.kr(buf), loop:loop, startPos:startPos);
	// XFade2 is a equal balance crossfade Ugen for
	// smooth panning between filtered and clean signal
	// bpfmix: -1 = first signal, 1 = second signal, 0 = crossfade
	sig = XFade2.ar(sig, BPF.ar(sig, freq, rq, 1/rq.sqrt), bpfmix);
	sig = sig * env;
	sig = Pan2.ar(sig, LFNoise0.ar(panOsc)* pan, amp);
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







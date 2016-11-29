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

s.boot;
b[\crickets][0].play;
b[\wall_hydrent][4].play; // this is the chain
b[\fences][1].play;

b[\radio_distortion][1].play

(SynthDef.new(\buf,{
	arg atk=0, sus=0, rel=3, c1=1, c2=(-1),
	buf=0, rate=1, startPos=0, freq=440, rq=1, bpfmix=0, loop=0, doneAction=2,
	pan=0, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:doneAction);
	sig = PlayBuf.ar(1, buf, rate*BufRateScale.kr(buf), loop:loop, startPos:startPos);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
SynthDef.new(\triggeredSampleNoise, {
	arg out=0, bufnum=0, rate=1, pan=0, trigHz=2, startPosNoiseHz=10,
	atk=0, sus=0, rel=3, c1=1, c2=(-1), doneAction=2;
    var trig, sig, env;
	trig = Impulse.kr(trigHz);
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:doneAction);
	sig = PlayBuf.ar(
		1,
		bufnum,
		rate * BufRateScale.kr(bufnum),
		trig,
		LFNoise0.kr(startPosNoiseHz) * BufFrames.kr(bufnum),
		1);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
    Out.ar(out,sig);
}).add;
)
(
SynthDef(\zigZagBuf, {
	arg atk=0.2, sus=0.5, rel=0.2, out=0,
	buf=0, rateMin = 0.25, rateMax = 20, rateChangeDur = 60,
	c1=1, c2=(-1), doneAction=2, amp = 1, pan=0;
	var rate, sig, env;
		env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:doneAction);
	rate=LFNoise2.kr(XLine.kr(rateMin, rateMax, rateChangeDur), 2);
	sig=PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, 1, 0, 1);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);

}).add;
)
// =================== Playback =============================================

// crickets
(
~crickets.free;
1.do{
	~buf = b[\crickets][0];
	~rate =  0.25;
	~crickets = Synth.head(s, \buf,
		[
			\buf, ~buf.bufnum,
			\atk, 1,
			\sus, (~buf.duration / ~rate ),
			\rel, 0.1,
			\rate, ~rate,
			\pan, 0,
			\loop, 1,
			\out, 0,
			\amp, 5,
		]
	);
}
)


// fences
(
1.do{
	~buf = b[\fences][[2,3,4].choose].postln;
	~rate =  rrand(0.3,1.3);
	~crickets = Synth.head(s, \buf,
		[
			\buf, ~buf.bufnum,
			\atk, 0.1,
			\sus, (~buf.duration / ~rate ),
			\rel, 0.1,
			\rate, ~rate,
			\pan, 0,
			\out, 0,
			\amp, 3,
		]
	);
}
)

(
SynthDef.new(\triggeredSampleNoise, {
	arg out=0, bufnum=0, rate=1, pan=0, trigHz=2, startPosNoiseHz=10,
	atk=0, sus=0, rel=3, c1=1, c2=(-1), doneAction=2;
    var trig, sig, env;
	trig = Impulse.kr(trigHz);
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:doneAction);
	sig = PlayBuf.ar(
		1,
		bufnum,
		rate * BufRateScale.kr(bufnum),
		trig,
		LFNoise0.kr(startPosNoiseHz) * BufFrames.kr(bufnum),
		1);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
    Out.ar(out,sig);
}).add;
)

(
~triggerNoise.stop;
~triggerNoise = Routine {
	loop {
		1.do{
			~buf = b[\wall_hydrent][[0,1,2,3].choose];
			~trigHz = rrand(0.5, 100);
			~rate =  [rrand(0.1,0.2), 0.25, 0.5, 1, 1.5].wchoose([0.05, 0.3, 0.3, 0.2, 0.05]);
			//~rate = 1.5;
			~wall_hydrent1= Synth.head(s, \triggeredSampleNoise,
				[
					\bufnum, ~buf.bufnum,
					\rate, ~rate.postln,
					\atk, 0.25,
					\sus, ((~buf.duration )) / ~rate,
					\rel, 0.25,
					\trigHz, ~trigHz,
					\startPosNoiseHz, rrand(1,5),
					\pan, 0,
					\out, 0,
					\amp, 5,
				]
			);
		};
		5.yield;
	}
}.play;
)

// standPipe is a mainstay and will definitely be in the installation
(
~standPipe = Routine({
	1.do{
		~buf = b[\wall_hydrent][[0,1,2,3].choose];
		~trigHz = rrand(0.5, 75);
		~rate =  [rrand(0.1,0.2), rrand(0.25, 0.5), rrand(0.5,0.75), rrand(0.75, 1.25), rrand(1.25, 1.5)].wchoose([0.05, 0.3, 0.3, 0.2, 0.05]);
		~standPipeSynth = Synth.head(s, \triggeredSampleNoise,
			[
				\bufnum, ~buf.bufnum,
				\rate, ~rate.postln,
				\atk, 0.25,
				\sus, ((~buf.duration )) / ~rate,
				\rel, 0.25,
				\trigHz, ~trigHz,
				\startPosNoiseHz, rrand(1,5),
				\pan, 0,
				\out, 0,
				\amp, 5,
			]
		);
	};
}).play;
)


(
~chain = Routine({
	2.do{
		~buf = b[\wall_hydrent][[4].choose];
		~trigHz = rrand(0.5, 10);
		"chain rate -> ".post;
		~rate =  [rrand(0.1,0.2), rrand(0.25, 0.5), rrand(0.5,0.75), rrand(0.75, 1.25), rrand(1.25, 1.5)].wchoose([0.05, 0.3, 0.3, 0.2, 0.05]).postln;
		~chainSynth = Synth.head(s, \triggeredSampleNoise,
			[
				\bufnum, ~buf.bufnum,
				\rate, ~rate,
				\atk, 0.25,
				\sus, ((~buf.duration )) / ~rate,
				\rel, 0.25,
				\trigHz, ~trigHz,
				\startPosNoiseHz, rrand(1,5),
				\pan, 0,
				\out, 0,
				\amp, 5,
			]
		);
	};
}).play;
)

// zigZagBuf is a new buffer synth that scans around a buffer really nice like
(
SynthDef(\zigZagBuf, {
	arg atk=0.2, sus=0.5, rel=0.2, out=0,
	buf=0, rateMin = 0.25, rateMax = 20, rateChangeDur = 60,
	c1=1, c2=(-1), doneAction=2, amp = 1, pan=0;
	var rate, sig, env;
		env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:doneAction);
	rate=LFNoise2.kr(XLine.kr(rateMin, rateMax, rateChangeDur), 2);
	sig=PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, 1, 0, 1);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);

}).add;
)

(
~zagFence.stop;
~zagFence = Routine {
	1.do{
		~buf = b[\fences][[0,1,2,3,4].choose];
		"bug rate -> ".post;
		~rate =  rrand(0.1,0.7).postln;
		~zagFenceSynth = Synth.head(s, \zigZagBuf,
			[
				\buf, b[\fences][[0,1,2,3,4].choose].bufnum,
				\atk, 1,
				\sus, (~buf.duration / ~rate ) * 1.0,
				\rel, 1,
				\rateMin, 0.25,
				\rateMax, 5,
				\rateDur, 30,
				\pan, 0,
				\out, 0,
				\amp, 1,
			]
		);
	}
}.play;
)





// conductor will organize and maintain controlled chaos through th install
(
~conductor.stop;
~conductor = Routine {
	loop{
		// decision engine ===================================================
		// stand pipe ----------------------------------------------------------
		~standPipeDecision = rrand(0.0,1.0);
		if (~standPipeDecision <= 0.65, {
			"hitting the stand pipe".postln;
			~standPipe = Routine({
				2.do{
					~buf = b[\wall_hydrent][[0,1,2,3].choose];
					"stand pipe trigger frequency -> ".post;
					~trigHz = rrand(0.1, 10).postln;
					"stand pipe rate -> ".post;
					~rate =  [rrand(0.1,0.2), rrand(0.25, 0.5), rrand(0.5,0.75), rrand(0.75, 1.25), rrand(1.25, 1.5)].wchoose([0.05, 0.3, 0.3, 0.2, 0.05]).postln;
					~standPipe = Synth.head(s, \triggeredSampleNoise,
						[
							\bufnum, ~buf.bufnum,
							\rate, ~rate,
							\atk, 0.25,
							\sus, ((~buf.duration )) / ~rate,
							\rel, 0.25,
							\trigHz, ~trigHz,
							\startPosNoiseHz, rrand(1,5),
							\pan, 0,
							\out, 0,
							\amp, 3.5,
						]
					);
				};
			}).play;
			}, {
				"stand pipe condition not met".postln;

			}
		);
		//---------------------------------------------------------------
		// chain ------------------------------------------------------------------
		~chainDecision = rrand(0.0, 1);
		if(~chainDecision <= 0.45, {
			"adjusting chains".postln;
			~chain = Routine({
				2.do{
					~buf = b[\wall_hydrent][[4].choose];
					~trigHz = rrand(0.5, 10);
					"chain rate -> ".post;
					~rate =  [rrand(0.1,0.2), rrand(0.25, 0.5), rrand(0.5,0.75), rrand(0.75, 1.25), rrand(1.25, 1.5)].wchoose([0.05, 0.3, 0.2, 0.2, 0.15]).postln;
					//~rate = 1;
					~chainSynth = Synth.head(s, \triggeredSampleNoise,
						[
							\bufnum, ~buf.bufnum,
							\rate, ~rate,
							\atk, 0.25,
							\sus, ((~buf.duration )) / ~rate,
							\rel, 0.25,
							\trigHz, ~trigHz,
							\startPosNoiseHz, rrand(1,5),
							\pan, 0,
							\out, 0,
							\amp, 5,
						]
					);
				};
				}
			).play;
			}, {
				"chain adjustment condition not met".postln;
			}
		);
		// -----------------------------------------------------------------------
		// crickets ----------------------------
		~cricketsDecision = rrand(0.0, 1.0);
		if( ~cricketsDecision <= 0.15, {
			"summer bugs".postln;
			~crickets = Routine {
				1.do{
					~buf = b[\crickets][0];
					"bug rate -> ".post;
					~rate =  rrand(0.1,0.5).postln;
					~crickets = Synth.head(s, \buf,
						[
							\buf, ~buf.bufnum,
							\atk, 1,
							\sus, (~buf.duration / ~rate ) * 0.5,
							\rel, 0.1,
							\rate, ~rate,
							\pan, 0,
							\loop, 1,
							\out, 0,
							\amp, 3,
						]
					);
				}
			}.play;
		}, {
				"the crickets legs are idle".postln;
		}
	);
		//-------------------------------------------------
		// zig zag fences
		~zigZagFenceDecision = rrand(0.0,1.0);
		if(~zigZagFenceDecision <= 0.25, {
			~zagFence = Routine {
				1.do{
					~buf = b[\fences][[0,1,2,3,4].choose];
					"wandering fence rate -> ".post;
					~rate =  rrand(0.1,0.7).postln;
					~zagFenceSynth = Synth.head(s, \zigZagBuf,
						[
							\buf, b[\fences][[0,1,2,3,4].choose].bufnum,
							\atk, 1,
							\sus, (~buf.duration / ~rate ) * 0.75,
							\rel, 1,
							\rateMin, 0.25,
							\rateMax, 5,
							\rateDur, 30,
							\pan, 0,
							\out, 0,
							\amp, 1,
						]
					);
				}
			}.play;
		}, {
				"".postln;
		});
		// ---------------------------------------------
		"Decision Throttle -> ".post;
		~decisionThrottle = rrand(4,9).postln;
		~decisionThrottle.yield;
	}
}.play;
)
s.quit;


BufDur.ir(b[\wall_hydrent][3].bufnum);



// THIS IS VERY HIGH POTENTIAL~!!!!
// mouse control of trigger rate and startpos
(
SynthDef(\triggeredSample, { arg out=0, bufnum=0;
    var trig, sig;
    trig = Impulse.kr(MouseY.kr(0.5, 200, 1));
	sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), trig, MouseX.kr(0, BufFrames.kr(bufnum)), 1);
	sig = Pan2.ar(sig, 0);
    Out.ar(out,sig);
}).play(s, [\out, 0, \bufnum, b[\wall_hydrent][3].bufnum]);
)


(
// accelerating pitch
~accPitchBuff = SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    var rate, sig;
    rate = XLine.kr(0.1, 200, 120);
	sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate, 1.0, 0.0, 1.0);
	sig = Pan2.ar(sig, 0);
	Out.ar(out, sig);
}).play(s, [
	\out, 0,
	\bufnum, b[\fences][[0,1,2,3].choose].bufnum
	]
);
)

~accPitchBuff.free;



	arg out=0, bufnum=0, rate=1, pan=0, trigHz=2, startPosNoiseHz=10,
	atk=0, sus=0, rel=3, c1=1, c2=(-1), doneAction=2;
    var trig, sig, env;
	trig = Impulse.kr(trigHz);
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:doneAction);



(
// zig zag around sound
~zigzag = SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0 |
    var rate,sig;
    rate = LFNoise2.kr(XLine.kr(0.25, 5, 60), 2);
	sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate, 1, 0, 1);
	sig = Pan2.ar(sig, 0);
    Out.ar(out,sig);
}).play(s, [
	\out, 0,
	\bufnum, b[\fences][[0,1,2,3,4].choose].bufnum
	]
);
)
~zigzag.free;
s.boot;
s.quit;
s.boot;
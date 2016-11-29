// reverb effect from scratch

(
SynthDef(\reverbFX, {
	arg in, predelay=0.1, reverbTime=1.8, dampHz=4500,
	mix= 0.15, amp=1, out=0;
	var dry, wet, temp, sig;
	dry = In.ar(in, 2); // stereophonic
	temp = In.ar(in,2);
	wet = 0;
	// predelay is the distance from the dry signal in a reverberating space
	temp = DelayN.ar(temp, 0, 2,predelay);
	// 16 feedback delays
	// experiment with 16
	32.do{
		temp = AllpassN.ar(temp, 0.05, {Rand(0.001, 0.05)}!2, reverbTime);
		temp = LPF.ar(temp, dampHz); // to simulate dampening
		wet = wet + temp;
	};
	sig = XFade2.ar(dry, wet, mix, amp);
	Out.ar(out, sig);
}).add;
)

~reverbBus = Bus.audio(s, 2);
~reverbSynth = Synth.tail(s, \reverbFX, [\in, ~reverbBus, \reverbTime, 3.2]);

(
Synth(\bpfbuf,
	[
		\buf, b[\humanVoices][0],
		\rel, rrand(0.5, 2.0),
		\rate, rrand(-2.0, 2.0).midiratio,
		\out, ~reverbBus,
	]
);
)

// function to create ReverbSynth on ServerTree to automate spawning
~createReverb = {~reverbSynth = Synth(\reverb, [\in, ~reverbBus])};
ServerTree.add(~createReverb);
ServerTree.removeAll;

s.boot;
(
SynthDef(\low_freq, {
	arg freq=50,phase=0, amp = 0.5,
	atk = 0.1, rel=0.1, curve=4;
	var noise, resonance, env;

	env = EnvGen.kr(Env.perc(
		atk,
		rel, level:1, curve: curve), doneAction:2);

	noise = SinOsc.ar(freq,phase);
	noise = noise * env;
	noise = Pan2.ar(noise,0,amp);
	Out.ar(0, noise);
}).add;
)
Scale.directory;
(
~lowfreq.stop;
~lowfreq = Routine{
	~min_dur = 2; // 60
	~max_dur = 5; // 120
	//~scale = Scale.partch_o1;
	~scale = Scale.harmonicMinor;
	loop {
		3.do{
			~rootNote = rrand(25,49);
			"oscilator frequency -> ".post;
			~note = ~scale.degreeToFreq(rrand(0,6), ~rootNote.midicps,rrand(0.6, 1.3)).postln;
			Synth(\low_freq, [
				\atk, ~min_dur * 0.1,
				\rel, ~min_dur * 0.1,
				\freq, ~note,
				\phase, rrand(-2pi, 2pi),
				\rel, rrand(~min_dur,~max_dur),
				\amp, 0.05,
			]);
		};
		~min_dur.yield;
	}
}.play;
)
~lowfreq.stop;

s.boot;


s.quit;

~scale = Scale.minor;
~scale.degrees;

~scale.degreeToFreq(rrand(0,6), 42.midicps, 1);
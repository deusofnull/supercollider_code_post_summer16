s.boot;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
s.reboot;


(
SynthDef(\resonantDust, {
	arg freq = 55, amp = 10, lpfhz = 900, n = 100, dustdensity=50;
	var noise, num, env;
	/*env = EnvGen.kr(Env.perc(
		atk,
		rel, level:1, curve: curve), doneAction:2);*/
	num = 100;
	noise = Mix.fill(num, {
		|i|
		Resonz.ar(
			Dust2.ar(dustdensity),
			freq * (1 + rrand(1,5)),
			0.01,
			10
		);
	}) * num.reciprocal; // scale to remove clipping
	noise =  Pan2.ar(noise, 0, amp);
	noise = LPF.ar(noise, lpfhz);
	Out.ar(0, noise);
}).add;
)


~resonantDust = Synth(\resonantDust, [\amp, 200, \lpfhz, 500, \freq, 40]);
~resonantDust.set(\lpfhz, 1500);
(~resonantDust.set(\dustdensity,250);
~resonantDust.set(\freq, 64);)
~resonantDust.set(\amp, 500);

~resonantDust.free;

~freqs = Pseq([55,65,45,37],inf);
f=~freqs.asStream;
f.next;

(
~resonantDust = Synth(\resonantDust, [\amp, 200, \lpfhz, 500]);

~resonantDustRoutine.stop;
~scale = Scale.harmonicMinor;
 ~freqs = Pseq([55,65,45,37],inf);
//~freqs = Pexprand(70, 80, inf);
f=~freqs.asStream;
~resonantDustRoutine = Routine{
	loop{
		~freq = f.next * rrand(0.9, 1.1);
		~resonantDust.set(\freq, ~freq);
		~freq.postln;
		0.5.wait;
	};
}.play;
)
~resonantDustRoutine.stop;


// Play notes from a scale
(
~resonantDust = Synth(\resonantDust, [\amp, 800, \lpfhz, 1000]);
~resonantDustRoutine.stop;
~scale = Scale.harmonicMinor.ratios;
~freqs = [43.65];
//~freqs = Pexprand(70, 80, inf);
f = ~freqs.asStream;
~resonantDustRoutine = Routine{
	loop{
		~freq = ~scale.choose * ~freqs;
		~resonantDust.set(\freq, ~freq);
		~freq.postln;
		5.wait;
	};
}.play;
)
s.boot;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)


(SynthDef.new(\noise_fm_vco, {
    arg noise_freq=250, noise_add=150, noise_mul = 300;
    var noise, mod_vco, car_vco;

    noise = LFNoise1.ar(noise_freq, noise_mul, noise_add);

    mod_vco = SinOsc.ar(noise, 0, noise * 8.0, noise);

    car_vco = SinOsc.ar(mod_vco, 0, 0.2);

    Out.ar(0, car_vco!2);
}
).add)


// noise_freq controls the oscilation speed of pitch changes
// noise add controls the pitch CENTER
// noise mul controls the width of pitch instability, how much the pitch fluxuates

~vco1=Synth.new(\noise_fm_vco, [noise_freq:[2.4], noise_add:25]);
~vco2=Synth.new(\noise_fm_vco, [noise_freq:[4.8], noise_add:[35]]);
~vco3=Synth.new(\noise_fm_vco, [noise_freq:[9.2], noise_add:[70]]);


~vco1.free;
~vco1.set(\noise_freq, 1);
~vco1.set(\noise_add, [1]);

~vco2.set(\noise_freq, 0.1);
~vco2.set(\noise_add, [0.5]);

~vco3.free;
~vco3.set(\noise_freq, 35);
~vco3.set(\noise_add, [350]);


// very simple delay
(SynthDef(\aDelay, { arg delay = 0.25;
	Out.ar(
		0,
		DelayN.ar(
			In.ar(0, 1),
			delay,
			delay
		)!2
	)
}).load(s);)

// groups  + play
(
~source = Group.head(s);
~effects = Group.tail(s);

~vco1=Synth.head(~source, \noise_fm_vco, [noise_freq:[2.4], noise_add:25, \noise_mul,1]);
~delay1=Synth.head(~effects, \aDelay);
)
~delay1.set(\delay, 0.15);

~vco1.set(\noise_freq,10);
~vco1.set(\noise_mul,1.5);
~vco1.set(\noise_mul,150);
~vco1.set(\noise_add,29);
~vco1.set(\noise_add,74);
~vco1.set(\noise_add,81);

s.quit;

// Routine, pattern of noise_add 35 33 30 27
(
~routine = Routine {
    loop{
		~vco1.set(\noise_add,35);
		35.postln;
		2.wait;
		~vco1.set(\noise_add,33);
		33.postln;
		2.5.wait;
		~vco1.set(\noise_add,30);
		30.postln;
		2.wait;
		~vco1.set(\noise_add,27);
		27.postln;
		3.wait;
	}
}.play;
)

~routine.stop;

s.quit;
dup({exprand(1,100)}, 20);
sort(dup({exprand(1.0,1000.0)}, 20));
s.boot;
s.quit;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)


(
play(
	{ CombN.ar(
		SinOsc.ar(
			midicps(
				LFNoise2.ar(
					1,
					48,
					LFSaw.ar([50, 100], 0, 3, 80)
				)
			),
			0, 0.2),
		1, 0.1, 2.5)
	}
)
)

({PMOsc.ar(
	LFNoise2.ar(200,50, LFSaw.ar([100,600],0,1,250),500,7) // carrier freq
	,LFNoise2.ar(200, 100, SinOsc.ar([20,1000],1,500),) // modfreq
	,1)}.play;
)

play(Blip.ar(freq:400, numharm:200, mul:1, add:0));

Line.kr
// 1.7 exercise
// Write a PMOSC with 3 Line.kr ugens for the first 3 arguments of PMOsc
({
	PMOsc.ar(
		carfreq: Line.kr(70,900,50),
		modfreq: Line.kr(50,75,50),
		pmindex: Line.kr(20,10,50),
		mul: 0.5,
		add: 0
	)!2
}.play;)

// 1.7 exercise that uses some delay to thicken the sound
(
play(
	{~shitty= CombN.ar(
		PMOsc.ar(
			carfreq: Line.kr(
				rrand(50,500),
				rrand(50,1000),25),
			modfreq: Line.kr(
				rrand(250,1000),
				rrand(50,250),25),
			pmindex: Line.kr(
				10,
				50,25),
			mul: 0.25,
			add: 0
		)!2;,
	1, 0.05, 2.5)
	}
)
)
~shitty.free;
s.quit;

//Figure 1.4
({
	~trig = Line.kr(50,49,5);
	Blip.ar(
		TRand.kr( // freq or VCO
			50, 200, // range
			Impulse.kr(~trig)), // trigger
		TRand.kr( // number of harmonics or VCF (kinda)
			1, 10, //range
			Impulse.kr(~trig)), // trigger
		Linen.kr(// mul, or amplitude, VCA
			Impulse.kr(~trig), // trigger
			0.1, // attack,
			2, // sustain,
			1/~trig) // trigger
	)!2
}.play)
			
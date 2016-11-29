{SinOsc.ar(200, 0, 0.5) }.play;

({
	3.do{
		var sin1, sin2, sin3, amp, out, hzs;
		amp = 0.1;
		hzs = [rrand(50,1000),rrand(50,1000),rrand(50,1000)];
		sin1 = SinOsc.ar(hzs.choose, mul:amp);
		sin2 = SinOsc.ar(hzs.choose, mul:amp);
		sin3 = SinOsc.ar(hzs.choose, mul:amp);

		// basic additive synthesis
		out = Mix.ar([sin1, sin2, sin3])!2;
		Out.ar(0, out);
	}
}.play;)

// same with sawtooth fbsine and regular sine
({
	3.do{
		var sin1, sin2, sin3, amp, out, hzs;
		amp = 0.1;
		hzs = [rrand(50,1000),rrand(50,1000),rrand(50,1000)];
		sin1 = LFSaw.ar(hzs.choose, mul:amp);
		sin2 = FBSineL.ar(hzs.choose, mul:amp);
		sin3 = SinOsc.ar(hzs.choose, mul:amp);

		// basic additive synthesis
		out = Mix.ar([sin1, sin2, sin3])!2;
		Out.ar(0, out);
	}
}.play;)
	
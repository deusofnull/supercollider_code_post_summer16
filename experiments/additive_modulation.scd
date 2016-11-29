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
		sin1 = LFSaw.ar(hzs.choose / 4, mul:amp);
		sin2 = FBSineL.ar(hzs.choose / 2, mul:amp);
		sin3 = SinOsc.ar(hzs.choose / 2, mul:amp);

		// basic additive synthesis
		out = Mix.ar([sin1, sin2, sin3])!2;
		Out.ar(0, out);
	}
}.play;)

// with a resonance filter for shits and giggles
({
	3.do{
		var sin1, sin2, sin3, amp, out, hzs;
		amp = 0.1;
		hzs = [rrand(50,1000),rrand(50,1000),rrand(50,1000)];
		sin1 = LFSaw.ar(hzs.choose / 4, mul:amp);
		sin2 = FBSineL.ar(hzs.choose / 2, mul:amp);
		sin3 = SinOsc.ar(hzs.choose / 2, mul:amp);

		// basic additive synthesis
		out = Mix.ar([sin1, sin2, sin3])!2;
		out = Resonz.ar(out, 500, XLine.kr(1, 0.001, 60));
		Out.ar(0, out);
	}
}.play;)


// base all 3 oscilators off first value
({
	1.do{
		var sin1, sin2, sin3, amp, out, hzs, hz;
		amp = 0.1;
		hz = rrand(125,400).round;
		sin1 = FBSineC.ar(hz, mul:amp);
		sin2 = FBSineC.ar(hz  * 2, mul:amp);
		sin3 = LFTri.ar(hz / 0.5, mul:amp);

		// basic additive synthesis
		out = Mix.ar([sin1, sin2, sin3])!2;
		out = Resonz.ar(out, hz, XLine.kr(1, 0.001, 10));
		Out.ar(0, out);
	}
}.play;)
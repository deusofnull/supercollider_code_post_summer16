play{FreeVerb.ar(SinOsc.ar(LFNoise0.kr(1, 1000, 1100)).clip)!2}


// Ex. 2: Untitled -- Jonatan Liljedahl (from sccode.org)
(play{p=LFPulse;tanh(p.ar([50,52])*p.kr([2,1]/4)+mean({|n|
(p.ar(n*3e2+99*p.kr(2-n/[1,5,7],
		(0..2)/10).sum+2e2)*p.kr(n+1*6,0,0.8).lag)}!2)/2)};)


// Ex. 3: "The Record Player is Broken" -- Scacinto (me!)
(play{a=LFNoise1.kr(0.7);b=a.range(4);c=Dust.ar(b);d=RLPF.ar(CombC.ar(c+LocalIn.ar()*b/2,4,b,b).clip,a.range(12000),b/8);LocalOut.ar(d);d!2};)


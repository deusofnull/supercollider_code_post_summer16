s.boot;


{SinOsc.ar(100*LFSaw.ar(LFNoise0.ar(XLine.kr(20,200,25))),0,0.5)}.play;



{SinOsc.ar(300*LFSaw.ar(2500), 0, 0.5,)}.play;


(
{SinOsc.ar(700*LFNoise0.ar(5), phase:0, mul:0.5)}.play;
{SinOsc.ar(350*LFNoise0.ar(50), phase:0, mul:0.5)}.play;
{SinOsc.ar(75*LFNoise0.ar(500), phase:0, mul:0.5)}.play;
)
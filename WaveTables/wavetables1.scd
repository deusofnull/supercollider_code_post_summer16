// Wavetables

Wavetable.sineFill(512, [1]).play;


(
s = Server.local;
b = Buffer.alloc(s,512,1);
b.sine1(1.0/[1,2.5,5.6,40,80,160],true,false,true);

SynthDef("help-OscN",{ arg out=0,bufnum=0;
    Out.ar(out,
        OscN.ar(bufnum, 500, 0, 0.5)
    )
}).play(s,[0,0,1,b.bufnum]);

)

// V Is from OscN
(
// change the buffer while its playing
s = Server.local;
b = Buffer.alloc(s, 4096, 1);
b.sine1(1.0/[1,2,3,4,6,20], true, true, true);

SynthDef("help-OscN",{ arg out=0,bufnum=0;
    Out.ar(out,
        OscN.ar(bufnum, [30,60.2], 0, 0.2)
    )
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)

(
Routine({
    var n = 32;
    100.do({
        b.sine1(Array.rand(n,0,10).cubed, true, true, true);
        0.25.wait;
    });
}).play;
)
b.free;
s.quit;
s.boot;
MIDIClient.init;
MIDIIn.connectAll;


// KORG NanoKontrol2 sends CC midi messages

~x = Synth(\varSawLagged, [\amp, 0.1]);
(
MIDIdef.cc(\sliders, {
	arg ...args;
	"slider ".post; args[1].postln;
	"value: ".post; args[0].postln;
	~freq = case
	{args[1] == 0}  {~x.set(\freq,args[0]*5); ("freq: ".post; args[0]*5).postln;}
	{args[1] == 1}  {~x.set(\detune,args[0]*0.1); ("detune: ".post; args[0]*1).postln;};
}, (0..7));

MIDIdef.cc(\topKnobs, {
	arg ...args;
	"topknob ".post; args[1].postln;
	"value: ".post; args[0].postln;
}, (16..23));

MIDIdef.cc(\s_buttons, {
	arg ...args;
	"s_button ".post; args[1].postln;
	"value: ".post; args[0].postln;
}, (32..39));
)


(
SynthDef(\varSawLagged, {
	arg freq=220, gate=1, amp=0.5, slideTime=0.17, lpffreq=550, width=0.15,
	detune=1.005, preamp=4, atk=0.01, decay=0.3, sus=0.4, rel=0.1 ;
	var sig, env= Env.adsr(atk, decay, sus, rel);
	freq = Lag.kr(freq, slideTime);
	sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: 2);
	sig = LPF.ar(sig, lpffreq);
	Out.ar(0, sig ! 2);
}).add;)

~x = Synth(\varSawLagged, [\amp, 0.1]);

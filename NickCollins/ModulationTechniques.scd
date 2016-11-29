s.boot;
FreqScope.new;



// Simple ring Modulation, C * M
({
var carrier, modulator, carrfreq, modfreq;

carrfreq= MouseX.kr(440,5000,'exponential');
modfreq= MouseY.kr(1,5000,'exponential');

carrier= SinOsc.ar(carrfreq,0,0.5).distort;
modulator= LFSaw.ar(modfreq,0,0.5).distort;

carrier*modulator;
}.scope)


// Amplitude Modulation
({
var carrier, modulator, carrfreq, modfreq;

carrfreq= MouseX.kr(440,5000,'exponential');
modfreq= MouseY.kr(1,5000,'exponential');

carrier= LFSaw.ar(carrfreq,0,0.5);
modulator= SinOsc.ar(modfreq,0,0.25, 0.25);

carrier*modulator;
}.scope)


// Frequency Modulationvia modulation index
(

var w, carrfreqslider, modfreqslider, modindexslider, synth;


w=Window("frequency modulation via modulation index", Rect(100, 400, 400, 300));

w.view.decorator = FlowLayout(w.view.bounds);


synth= {arg carrfreq=440, modfreq=1, modindex=0;

SinOscFB.ar(carrfreq + (modindex*modfreq*SinOscFB.ar(modfreq)),0,0.25)

}.scope;


carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\carrfreq, ez.value)});

w.view.decorator.nextLine;


modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\modfreq, ez.value)});

w.view.decorator.nextLine;

modindexslider= EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 100, 'linear', 0.01, 0.0), {|ez|  synth.set(\modindex, ez.value)});


w.front;

)
synth.stop;


(
SynthDef(\pmDistort, {
	arg atk=0, sus=0, rel=3, c1=1, c2=(-1),
	carfreq = 220, modfreq = 100, modindex = 1,
	pan=0, amp=1, out=0;
	var carrier, modulator, env,
	conversion= 2pi/(s.sampleRate);

	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]), doneAction:2);
	modulator = SinOscFB.ar(modfreq);
	carrier = SinOscFB.ar(carfreq, ( (modfreq * modindex) * conversion * modulator), 0.25);

	carrier = Pan2.ar(carrier, pan, amp);

	Out.ar(out, carrier);
	}
).add;
)








// Phase Modulation
(
var w, carrfreqslider, modfreqslider, modindexslider,  ampslider, posslider, synth;
var conversion= 2pi/(s.sampleRate); //needed to avoid phase being adjusted too wildly


w=Window("phase modulation via modulation index", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);


synth= {
	arg carrfreq=440, modfreq=1, modindex=0, amp=0.05, pos=0;
	Pan2.ar(
		SinOscFB.ar(carrfreq, ( (modfreq*modindex)*conversion*SinOscFB.ar(modfreq)),amp)!2,
		pos);

}.play;


carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;
modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;

//bigger range since adjusting phase directly and not frequency
modindexslider= EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 100, 'linear', 0.01, 0.0), {|ez|  synth.set(\modindex, ez.value)});

ampslider = EZSlider(w, 300@50, "amp", ControlSpec(0.05, 0.2, '\linear', 0.005, 0.05), {|ez|
	synth.set(\amp, ez.value)});

posslider = EZSlider(w, 300@50, "pos", ControlSpec(-1, 1, '\linear', 0.005, 0.0), {|ez|
	synth.set(\pos, ez.value)});
w.front;
)

s.quit;
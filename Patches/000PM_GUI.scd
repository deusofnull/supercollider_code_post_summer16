// Phase Modulation GUI synth
(
var w, carrfreqslider, modfreqslider, modindexslider,  ampslider, posslider, synth;
var conversion= 2pi/(s.sampleRate); //needed to avoid phase being adjusted too wildly


w=Window("phase modulation via modulation index", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);


~synth= {
	arg carrfreq=50, modfreq=1, modindex=0, amp=0.00, pos=0;
	Pan2.ar(
		SinOscFB.ar(carrfreq, ( (modfreq*modindex)*conversion*SinOscFB.ar(modfreq)),amp)!2,
		pos);

}.play;


carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 50), {|ez|  ~synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;
modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  ~synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;

//bigger range since adjusting phase directly and not frequency
modindexslider= EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 250, 'linear', 0.01, 0.0), {|ez|  ~synth.set(\modindex, ez.value)});

ampslider = EZSlider(w, 300@50, "amp", ControlSpec(0.00, 0.2, '\linear', 0.005, 0.00), {|ez|
	~synth.set(\amp, ez.value)});

posslider = EZSlider(w, 300@50, "pos", ControlSpec(-1, 1, '\linear', 0.001, 0.0), {|ez|
	~synth.set(\pos, ez.value)});
w.front;

)


~synth.free;



s;

s.quit;
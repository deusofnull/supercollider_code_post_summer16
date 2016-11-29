// Composition with Supercollider



// ===========================Scheduling with System Clock============================

// wait two seconds and print foo
SystemClock.sched(2, {"foo".postln;});

// The last thing to be evaluated in the function in the second argument is a repeat argument.

// This will print foo right away, and schedule another SystemClock event to print foo at a random time between 0-1 seconds
SystemClock.sched(0, {"foo".postln; 1.0.rand;});

// To clear scheduled events, use this
SystemClock.clear;

// ===========================Scheduling with Tempo Clock============================

// TempClock allows you to schedule events according to beats, rather than seconds

// TempoClock must be instansiated on its own, and there can be many TempoClocks, where there is only ever one SystemClock / AppClock

(
t = TempoClock.new; // instansiate new tempo clock
t.sched(0, {"Hello!".postln; 1;});
)

t.tempo = 2; // twice as fast!
t.tempo = 0.25; // A quarter as fast

t.clear;  // clear the tempoClock

// TempoClock is helpful when using bar-based scheduling in metric music



// ======================== Scheduling with Routines ===================================

// Routines allow you to execute functions piece by piece, when they are called.

// Routines are similar to functions, and contain one at the core.


(
r = Routine({
	"foo".yield;
	"bar".yield;
});
)
r.value; // foo
r.value; // bar
r.value; // we've reached the end, so it returns nil


// Since routines are similar and can take the place of functions, you can evaluate a Routine in a Clock, and yielding a number in the Routine will be used by the Clock to reschedule the Routine.
(
r = Routine({
	"foo".postln;
	1.yield; // reschedule after 1 second
	"bar".postln;
	1.yield; // reschedule after 1 second
	"foobar".postln;
});
SystemClock.sched(0,r);
)

// Music Example

// Abstract thinking

s.boot;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)



(
~freq = rrand(30,50);
n = 50;
{Mix.fill(n, {|i|
	Resonz.ar(Dust2.ar(5), ~freq * (1 + i), 0.01, 100)})!2
	* n.reciprocal; // scale to ensure no clipping
}.play;
)




// Resonant Dust Synth with Tempo Clock control

(
~freq = 37; // 55, 65, 45, 37
~amp = 10;
~lpfhz = 900;
n = 100;
{~out = Mix.fill(n, {|i|
	Resonz.ar(Dust2.ar(5), ~freq * (1 + rrand(1,5)), 0.01, 100)})!2
	* n.reciprocal; // scale to ensure no clipping
	~out = Pan2.ar(~out, 0, ~amp);
	~out = LPF.ar(~out, 900);
}.play;
)

(
SynthDef(\resonantDust, {
	arg freq = 55, amp = 10, lpfhz = 900, n = 100;
	var noise, num, env;
	/*env = EnvGen.kr(Env.perc(
		atk,
		rel, level:1, curve: curve), doneAction:2);*/
	num = 25;
	noise = Mix.fill(num, {
		|i|
		Resonz.ar(
			Dust2.ar(5),
			freq * (1 + rrand(1,5)),
			0.01,
			10
		);
	}) * num.reciprocal; // scale to remove clipping
	noise =  Pan2.ar(noise, 0, amp);
	noise = LPF.ar(noise, lpfhz);
	Out.ar(0, noise);
}).add;
)

s.boot;

~resonantDust = Synth(\resonantDust, [\amp, 200, \lpfhz, 500]);
~resonantDust.set(\freq, 37, \lpfhz, 500);

~freqs = Pseq([55,65,45,37],inf);
f=~freqs.asStream;
f.next;

(
~resonantDustRoutine.stop;
// ~freqs = Pseq([55,65,45,37],inf);
~freqs = Pexprand(37, 200,inf);
f=~freqs.asStream;
~resonantDustRoutine = Routine{
	loop{
		~freq = f.next;
		~resonantDust.set(\freq, ~freq);
		~freq.postln;
		10.wait;
	};
}.play;
)
r.stop;
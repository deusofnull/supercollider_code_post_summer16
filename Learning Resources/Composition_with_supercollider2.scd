// Patterns

// randomly selected frequency duration 0.1 second
~stupidPat = Pbind(\freq, Prand([300,500, 231.1, 399.2],30), \dur, Pexprand(0.1,1,inf)).play;

~stupidPat.stop;
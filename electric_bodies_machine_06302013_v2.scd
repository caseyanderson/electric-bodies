//Electric Bodies, for Machine Project's part of Intimate Science at ACCD
//v2, receiving from Arduino (via Python)

s.boot;

p = ProxySpace.push;
//all of these occur randomly, or are cued by responders

h = Array.newClear( 10 );
h.fill( 0 );

///////// SYNTHDEFs /////////

SynthDef( \sin,	{ | amp = 0.1, freq = 60, trig =1, lag_time = 0.2, multiplier = 1 |
	var env, lag, sig;
	env = EnvGen.kr( Env.asr( 0.001, 0.9, 0.001 ), trig, doneAction: 0 );
	lag = Lag.kr( freq, lag_time );
	//sig = SinOsc.ar(freq * multiplier, 0.0, amp ) * env;
	sig = RLPF.ar( LFPulse.ar( SinOsc.kr( lag * multiplier, 0, 10, 21 ), lag, 0.1 ), lag * multiplier, lag.linlin( 20, 10300, 2, 15 ) ).clip2(0.5) * env;
	Out.ar( [ 0, 1  ], sig );
}).add;

h[ 0 ] = Synth( \sin);
h[ 2 ] = Synth( \sin );
h[ 4 ] = Synth( \sin );

h[ 0 ].set( \lag_time, 5 );
h[ 0 ].set( \amp, 0.05 );
h[ 0 ].set(\multiplier, 1 );

h[ 2 ].set( \lag_time, 5 );
h[ 2 ].set( \amp, 0.05 );
h[ 2 ].set(\multiplier, 2 );

h[ 4 ].set( \lag_time, 5 );
h[ 4 ].set( \amp, 0.05 );
h[ 4 ].set(\multiplier, 3 );

///////// RESPONDERS /////////
//for analysis
x = OSCFunc( { | msg, time, addr, port |
	f = msg[1].asFloat;

	//f.postln;
	( "m1 is " + f ).postln;
	h[0].set( \freq, f );
}, '/m1' );

y = OSCFunc( { | msg, time, addr, port |
	f = msg[1].asFloat;

	( "m2 is " + f ).postln;
	h[2].set( \freq, f );
}, '/m2' );

z = OSCFunc( { | msg, time, addr, port |
	f = msg[1].asFloat;
//	f = msg[1];

	( "m3 is " + f).postln;
	h[4].set( \freq, f);
}, '/m3 ');

/////////

h[1].remove;
h[3].remove;
h[5].remove;

x.remove;
y.remove;
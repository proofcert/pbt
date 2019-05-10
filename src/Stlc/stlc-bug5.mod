module stlc-bug5.
accumulate kernel.
accumulate stlc.
accumulate stlc-tcc.
accumulate stlc-wt.
accumulate stlc-value.
accumulate stlc-step-bug5.
accumulate nat.
accumulate lst.
accumulate fpc-qbound.
accumulate fpc-pair.

% Tests
cexpres E E' T :-
	itsearch H SH,
	check (pair (qgen (qheight H)) (qgen (qsize SH _))) (wt null E T),
	interp (step E E'),
	not (interp (wt null E' T)).

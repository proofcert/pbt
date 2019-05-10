module stlc-bug7.
accumulate kernel.
accumulate stlc.
accumulate stlc-tcc.
accumulate stlc-wt.
accumulate stlc-value.
accumulate stlc-step-bug7.
accumulate nat.
accumulate lst.
accumulate fpc-qbound.
accumulate fpc-qrandom.
accumulate fpc-pair.

% Tests
cexprog E T :-
	itsearch H SH,
	check (pair (qgen (qheight H)) (qgen (qsize SH _))) (wt null E T),
	interp (wt null E T),
	not (interp (progress E)).

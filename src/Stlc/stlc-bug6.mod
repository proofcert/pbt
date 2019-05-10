module stlc-bug6.
accumulate kernel.
accumulate stlc.
accumulate stlc-tcc.
accumulate stlc-wt.
accumulate stlc-value.
accumulate stlc-step-bug6.
accumulate nat.
accumulate lst.
accumulate fpc-qbound.
accumulate fpc-pair.

% Tests
cexprog E T :-
	itsearch H SH,
	check (pair (qgen (qheight H)) (qgen (qsize SH _))) (wt null E T),
	not (interp (progress E)).

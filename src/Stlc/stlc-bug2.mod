module stlc-bug2.
accumulate kernel.
accumulate stlc.
accumulate stlc-tcc.
accumulate stlc-wt.
accumulate stlc-value-bug2.
accumulate stlc-step.

% Tests
cexprog E T :-
	check (pair (qgen (qheight 5)) (qgen (qsize 9 _))) (is_exp E),
	%check (qgen (qheight 1)) (is_ty T),
	interp (wt null E T),
	not (interp (progress E)).

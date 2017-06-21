module stlc-bug2.
accumulate kernel.
accumulate stlc.
accumulate stlc-wt.
accumulate stlc-value-bug2.
accumulate stlc-step.

% Tests
cex_prog_2 E T :-
	check (qgen (qheight 5)) (is_exp E),
	check (qgen (qheight 1)) (is_ty T),
	interp (wt null E T),
	not (interp (progress E)).

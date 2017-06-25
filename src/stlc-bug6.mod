module stlc-bug6.
accumulate kernel.
accumulate stlc.
accumulate stlc-tcc.
accumulate stlc-wt.
accumulate stlc-value.
accumulate stlc-step-bug6.

% Tests
cexprog E T :-
	check (pair (qgen (qheight 6)) (qgen (qsize 12 _))) (is_exp E),
	%check (qgen (qheight 1)) (is_ty T),
	interp (wt null E T),
	not (interp (progress E)).

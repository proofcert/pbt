module stlc-bug7.
accumulate kernel.
accumulate stlc.
accumulate stlc-wt.
accumulate stlc-value.
accumulate stlc-step-bug7.

% Tests
cexprog E T :-
	check (qgen (qheight 4)) (is_exp E),
	%check (qgen (qheight 1)) (is_ty T),
	interp (wt null E T),
	not (interp (progress E)).

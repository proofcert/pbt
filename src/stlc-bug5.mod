module stlc-bug5.
accumulate kernel.
accumulate stlc.
accumulate stlc-wt.
accumulate stlc-value.
accumulate stlc-step-bug5.

% Tests
cexpres E E' T :-
	check (qgen (qheight 6)) (is_exp E),
	%check (qgen (qheight 3)) (is_exp E'),
	%check (qgen (qheight 1)) (is_ty T),
	interp (step E E'),
	interp (wt null E T),
	not (interp (wt null E' T)).

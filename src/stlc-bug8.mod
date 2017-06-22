module stlc-bug8.
accumulate kernel.
accumulate stlc.
accumulate stlc-wt-bug8.
accumulate stlc-value.
accumulate stlc-step.

% Tests
cexpres E E' T :-
	check (pair (qgen (qheight 3)) (qgen (qsize 6 _))) (is_exp' null E),
	%check (qgen (qheight 3)) (is_exp E'),
	%check (qgen (qheight 1)) (is_ty T),
	interp (step E E'),
	interp (wt null E T),
	not (interp (wt null E' T)).

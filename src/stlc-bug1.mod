module stlc-bug1.
accumulate kernel.
accumulate stlc.
accumulate stlc-wt-bug1.
accumulate stlc-value.
accumulate stlc-step.

% Tests
cexprog E T :-
	check (qgen (qheight 4)) (is_exp E),
	check (qgen (qheight 1)) (is_ty T),
	interp (wt null E T),
	not (interp (progress E)).

cexpres E E' T :-
	check (qgen (qheight 4)) (is_exp' null E),
	%check (qgen (qheight 4)) (is_exp E'),
	%check (qgen (qheight 1)) (is_ty T),
	interp (step E E'),
	interp (wt null E T),
	not (interp (wt null E' T)).

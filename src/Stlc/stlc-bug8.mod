module stlc-bug8.
accumulate kernel.
accumulate stlc.
accumulate stlc-tcc.
accumulate stlc-wt-bug8.
accumulate stlc-value.
accumulate stlc-step.
accumulate nat.
accumulate lst.
accumulate fpc-qbound.
accumulate fpc-pair.

% Tests
% Dubious: iterative deepening? (and wt generator, later)
cexpres E E' T :-
	check (pair (qgen (qheight 3)) (qgen (qsize 6 _))) (is_exp' null E),
	interp (step E E'),
	interp (wt null E T),
	not (interp (wt null E' T)).

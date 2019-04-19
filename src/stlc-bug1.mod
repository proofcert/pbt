module stlc-bug1.
accumulate kernel.
accumulate stlc.
accumulate stlc-tcc.
accumulate stlc-wt-bug1.
accumulate stlc-value.
accumulate stlc-step.

% Tests
cexprog E T :-
	check (pair (qgen (qheight 4)) (qgen (qsize 6 _))) (is_exp E),
	%check (qgen (qheight 1)) (is_ty T),
	interp (wt null E T),
	not (interp (progress E)).

cexpres E E' T :-
	check (pair (qgen (qheight 4)) (qgen (qsize 8 _))) (is_exp' null E),
	%check (qgen (qheight 4)) (is_exp E'),
	%check (qgen (qheight 1)) (is_ty T),
	interp (step E E'),
	interp (wt null E T),
	not (interp (wt null E' T)).

% Note that pairing could be used to bound the size of random terms
qcprog :-
	check (qtries 1000) (is_exp E),
	interp (wt null E T),
	not (interp (progress E)),
	term_to_string E Estr, print "E =", print Estr,
	term_to_string T Tstr, print "T =", print Tstr.

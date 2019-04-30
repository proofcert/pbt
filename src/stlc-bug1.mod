module stlc-bug1.
accumulate kernel.
accumulate stlc.
accumulate stlc-tcc.
accumulate stlc-wt-bug1.
accumulate stlc-value.
accumulate stlc-step.

% Tests
cexprog E T :-
	%Cert = (pair (qgen (qheight 4)) (qgen (qsize 6 N))),
	%Cert = (qgen (qheight 4)),
	Cert = (qgen (qsize 6 N)),
	check Cert (is_exp E),
 term_to_string Cert Certstr, print Certstr,
	%check (qgen (qheight 1)) (is_ty T),
	interp (wt null E T),
 term_to_string E Estr, print Estr,
	not (interp (progress E)).

cexpres E E' T :-
	check (pair (qgen (qheight 4)) (qgen (qsize 8 _))) (is_exp' null E),
	%check (qgen (qheight 4)) (is_exp E'),
	%check (qgen (qheight 1)) (is_ty T),
	interp (step E E'),
	interp (wt null E T),
	not (interp (wt null E' T)).

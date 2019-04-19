module cfg-bug3.
accumulate kernel.
accumulate cfg.
accumulate cfg-ss.
accumulate cfg-aa-bug3.
accumulate cfg-bb.

% Tests
test Cert W N :-
	check Cert (is_ablist W),
	interp (count a W N),
	interp (count b W N),
	not (interp (ss W)).

b3c W N :-
	test (qgen (qheight 5)) W N.

b3c' W N :-
	Ws = [(qw "ab-a" 1), (qw "ab-b" 1),
	      (qw "abl-null" 1), (qw "abl-cons" 1) ],
	test (qtries 1000 Ws) W N.

qc :-
	b3c' W N,
	term_to_string W Wstr, print "W =", print Wstr,
	term_to_string N Nstr, print "N =", print Nstr.

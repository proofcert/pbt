module cfg-bug2.
accumulate kernel.
accumulate cfg.
accumulate cfg-ss.
accumulate cfg-aa.
accumulate cfg-bb-bug2.

% Tests
test Cert W N1 N2 :-
	check Cert (is_ablist W),
	interp (count a W N1),
	interp (count b W N2),
	not (N1 = N2).

b2c W N1 N2 :-
	test (qgen (qheight 2)) W N1 N2.

b2c' W N1 N2 :-
	Ws = [(qw "ab-a" 1), (qw "ab-b" 1),
	      (qw "abl-null" 1), (qw "abl-cons" 1) ],
	test (qtries 2 Ws) W N1 N2.

qc :-
	b2c' W N1 N2,
	term_to_string W Wstr, print "W =", print Wstr,
	term_to_string N1 N1str, print "N1 =", print N1str,
	term_to_string N2 N2str, print "N2 =", print N2str.

module cfg-bug1.
accumulate kernel.
accumulate cfg.
accumulate cfg-ss-bug1.
accumulate cfg-aa.
accumulate cfg-bb.

% Tests
test Gen W N1 N2 :-
	check Gen (is_ablist W),
	interp (count a W N1),
	interp (count b W N2),
	not (N1 = N2).

b1c W N1 N2 :-
	test (qgen (qheight 2)) W N1 N2.

b1c' W N1 N2 :-
	Ws = [(qw "ab-a" 1), (qw "ab-b" 1),
	      (qw "abl-null" 1), (qw "abl-cons" 1) ],
	test (qtries 100 Ws) W N1 N2.

qc :-
	random.init 42,
	b1c' W N1 N2,
	term_to_string W Wstr, print "W =", print Wstr,
	term_to_string N1 N1str, print "N1 =", print N1str,
	term_to_string N2 N2str, print "N2 =", print N2str.

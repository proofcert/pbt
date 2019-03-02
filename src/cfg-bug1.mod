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
	test (qtries 1) W N1 N2.

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
	test (qtries 1) W N.

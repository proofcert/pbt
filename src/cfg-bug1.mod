module cfg-bug1.
accumulate kernel.
accumulate cfg.
accumulate cfg-ss-bug1.
accumulate cfg-aa.
accumulate cfg-bb.

% Tests
b1c W N1 N2 :-
	check (qgen (qheight 2)) (is_ablist W),
	interp (count a W N1),
	interp (count b W N2),
	not (N1 = N2).

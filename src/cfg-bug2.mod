module cfg-bug2.
accumulate kernel.
accumulate cfg.
accumulate cfg-ss.
accumulate cfg-aa.
accumulate cfg-bb-bug2.

% Tests
b2c W N1 N2 :-
	check (qgen (qheight 2)) (is_ablist W),
	interp (count a W N1),
	interp (count b W N2),
	not (N1 = N2).

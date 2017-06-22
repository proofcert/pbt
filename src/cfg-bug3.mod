module cfg-bug3.
accumulate kernel.
accumulate cfg.
accumulate cfg-ss.
accumulate cfg-aa-bug3.
accumulate cfg-bb.

% Tests
b3c W N :-
	check (qgen (qheight 5)) (is_ablist W),
	interp (count a W N),
	interp (count b W N),
	not (interp (ss W)).

module rev.
accumulate kernel. % TODO: Modularity

prog (is_elt a) (tt).
prog (is_elt b) (tt).
prog (is_elt c) (tt).

prog (is_eltlist null) (tt).
prog (is_eltlist (cons Hd Tl)) (and (is_elt Hd) (is_eltlist Tl)).

prog (rev null null) (tt).
prog (rev (cons X XS) RS) (and (rev XS SX) (append SX (cons X null) RS)).

% Test
cexrev XS YS :-
	check (qgen (qheight 3)) (is_eltlist XS),
	%check (qgen (qheight 3)) (is_eltlist YS),
	interp (rev XS YS),
	not (XS = YS).

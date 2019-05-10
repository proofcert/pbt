module stlc-bug4.
accumulate kernel.
accumulate stlc.
accumulate stlc-tcc-bug4.
accumulate stlc-wt.
accumulate stlc-value.
accumulate stlc-step.
accumulate nat.
accumulate lst.
accumulate fpc-qbound.
accumulate fpc-pair.

prog (is_cnt plus) (tt).
%prog (tcc plus (funTy intTy (funTy intTy intTy))) (tt).

prog (is_value (app (c plus) V)) (is_value V).

prog (step (app (app (c plus) X) Y) Z) (and (is_value X) (and (is_value Y) (add_value X Y Z))).
prog (add_value (c (toInt zero)) (c X) (c X)) (tt).
prog (add_value (c (toInt (succ X))) (c Y) (c (toInt (succ Z)))) (add_value (c (toInt X)) (c Y) (c (toInt Z))).

% Tests
cexprog E T :-
	itsearch H SH,
	check (pair (qgen (qheight H)) (qgen (qsize SH _))) (wt null E T),
	not (interp (progress E)).

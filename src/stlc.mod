module stlc.
accumulate kernel.

%% Lambda-terms

prog (is_ty intTy) (tt).
prog (is_ty (funTy Ty1 Ty2)) (and (is_ty Ty1) (is_ty Ty2)).
prog (is_ty listTy) (tt).

prog (is_cnt cns) (tt).
prog (is_cnt hd) (tt).
prog (is_cnt tl) (tt).
prog (is_cnt nl) (tt).
prog (is_cnt (toInt I)) (is_nat I).

prog (is_exp (c Cnt)) (is_cnt Cnt).
prog (is_exp (app Exp1 Exp2)) (and (is_exp Exp1) (is_exp Exp2)).
prog (is_exp (lam ExpX Ty)) (and (nabla x\ is_exp (ExpX x)) (is_ty Ty)).
prog (is_exp error) (tt).

prog (is_elt (bind E T)) (and (is_exp E) (is_ty T)).

prog (is_eltlist null) (tt).
prog (is_eltlist (cons E L)) (and (is_elt E) (is_eltlist L)).

prog (tcc (toInt _) intTy) (tt).
prog (tcc nl listTy) (tt).
prog (tcc hd (funTy listTy intTy)) (tt).
prog (tcc tl (funTy listTy listTy)) (tt).
prog (tcc cns (funTy intTy (funTy listTy listTy))) (tt).

% "Polymorphic" membership
prog (memb X (cons X _)) (tt).
prog (memb X (cons Y Gamma)) (memb X Gamma).

% Bug 1
prog (wt Ga M A) (memb (bind M A) Ga).
prog (wt _ error _) (tt).
prog (wt _ (c M) T) (tcc M T).
prog (wt E (app M N) U) (and (wt E M (funTy T U)) (wt E N U)). % exists T
prog (wt Ga (lam F Tx) (funTy Tx T)) (nabla x\ wt (cons (bind x Tx) Ga) (F x) T).

prog (is_value (c _)) (tt).
prog (is_value (lam _ _)) (tt).
prog (is_value (app (c cns) V)) (is_value V).
prog (is_value (app (app (c cns) V1) V2)) (and (is_value V1) (is_value V2)).

prog (is_error error) (tt).
prog (is_error (app (c hd) (c nl))) (tt).
prog (is_error (app (c tl) (c nl))) (tt).
prog (is_error (app E1 _)) (is_error E1).
prog (is_error (app E1 E2)) (and (is_value E1) (is_error E2)).

prog (step (app (c hd) (app (app (c cns) X) XS)) X) (and (is_value X) (is_value XS)).
prog (step (app (c tl) (app (app (c cns) X) XS)) XS) (and (is_value X) (is_value XS)).
prog (step (app (lam M T) V) (M V)) (is_value V). % W = M V, dynamic pattern OK?
prog (step (app M1 M2) (app M1' M2)) (step M1 M1').
prog (step (app V M2) (app V M2')) (and (is_value V) (step M2 M2')).

prog (progress V) (is_value V).
prog (progress E) (is_error E).
prog (progress M) (step M N).

% Tests
cex_prog_1 E T :-
	check (qgen (qheight 4)) (is_exp E),
	check (qgen (qheight 1)) (is_ty T),
	interp (wt null E T),
	not (interp (progress E)).

module stlc.

%% Lambda-terms

prog (is_ty intTy) (tt).
prog (is_ty (funTy Ty1 Ty2)) (and (is_ty Ty1) (is_ty Ty2)).
prog (is_ty listTy) (tt).

prog (is_cnt cns) (tt).
prog (is_cnt hd) (tt).
prog (is_cnt tl) (tt).
prog (is_cnt nl) (tt).
prog (is_cnt (toInt I)) (is_nat I).

% Simple generation
prog (is_exp (c Cnt)) (is_cnt Cnt).
prog (is_exp (app Exp1 Exp2)) (and (is_exp Exp1) (is_exp Exp2)).
prog (is_exp (lam ExpX Ty)) (and (nabla x\ is_exp (ExpX x)) (is_ty Ty)).
prog (is_exp error) (tt).

% Maintaining a context of lambda variables
prog (is_exp' _ (c Cnt)) (is_cnt Cnt).
prog (is_exp' Ctx (app Exp1 Exp2)) (and (is_exp' Ctx Exp1) (is_exp' Ctx Exp2)).
prog (is_exp' Ctx (lam ExpX Ty)) (and (nabla x\ is_exp' (cons x Ctx) (ExpX x)) (is_ty Ty)).
prog (is_exp' _ error) (tt).
prog (is_exp' Ctx X) (tt) :-
	memb_ctx Ctx X.

% For this selection to count as one unfolding, we run it outside of prog
memb_ctx (cons X Ctx) X.
memb_ctx (cons _ Ctx) X :-
	memb_ctx Ctx X.

prog (is_elt (bind E T)) (and (is_exp E) (is_ty T)).

prog (is_eltlist null) (tt).
prog (is_eltlist (cons E L)) (and (is_elt E) (is_eltlist L)).

% "Polymorphic" membership
prog (memb X (cons X _)) (tt).
prog (memb X (cons Y Gamma)) (memb X Gamma).

prog (is_error error) (tt).
prog (is_error (app (c hd) (c nl))) (tt).
prog (is_error (app (c tl) (c nl))) (tt).
prog (is_error (app E1 _)) (is_error E1).
prog (is_error (app E1 E2)) (and (is_value E1) (is_error E2)).

prog (progress V) (is_value V).
prog (progress E) (is_error E).
prog (progress M) (step M N).

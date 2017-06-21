module test.

% Interpreter

interp tt.

interp (and G1 G2) :-
	interp G1,
	interp G2.

interp (or G1 G2) :-
	interp G1;
	interp G2.

interp (nabla G) :-
	pi x\ interp (G x).

interp A :-
	prog A G,
	interp G.

% Checker

check Cert tt :-
	tt_expert Cert.

check Cert (and G1 G2) :-
	and_expert Cert Cert1 Cert2,
	check Cert1 G1,
	check Cert2 G2.

check Cert (or G1 G2) :-
	or_expert Cert Cert' Choice,
	(
		(Choice = left, check Cert' G1)
	;
		(Choice = right, check Cert' G2)
	).

check Cert (nabla G) :-
	pi x\ check Cert (G x).

check Cert A :-
	prog_expert Cert Cert',
	prog A G,
	check Cert' G.

% Program

%% Natural numbers

prog (is_nat zero) (tt).
prog (is_nat (succ N)) (is_nat N).

prog (leq zero _) (tt).
prog (leq (succ X) (succ Y)) (leq X Y).

prog (gt (succ _) zero) (tt).
prog (gt (succ X) (succ Y)) (gt X Y).

%% Lists

prog (is_natlist null) (tt).
prog (is_natlist (cons Hd Tl)) (and (is_nat Hd) (is_natlist Tl)).

prog (ord null) (tt).
prog (ord (cons X null)) (is_nat X).
prog (ord (cons X (cons Y Rs))) (and (leq X Y) (ord (cons Y Rs))).

prog (ord_bad null) (tt).
prog (ord_bad (cons X null)) (is_nat X).
prog (ord_bad (cons X (cons Y Rs))) (and (leq X Y) (ord_bad Rs)).

prog (ins X null (cons X null)) (is_nat X).
prog (ins X (cons Y Ys) (cons X (cons Y Ys))) (leq X Y).
prog (ins X (cons Y Ys) (cons Y Rs)) (and (gt X Y) (ins X Ys Rs)).

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

% "Quick"-style FPC

tt_expert (qgen _).

and_expert (qgen (qheight H)) (qgen (qheight H)) (qgen (qheight H)).
and_expert (qgen (qsize In Out)) (qgen (qsize In Mid)) (qgen (qsize Mid Out)).

prog_expert (qgen (qheight H)) (qgen (qheight H')) :-
	H > 0,
	H' is H - 1.
prog_expert (qgen (qsize In Out)) (qgen (qsize In' Out)) :-
	In > 0,
	In' is In - 1.

% Tests
cex_ord_bad N L :-
	check (qgen (qheight 4)) (and (is_nat N) (is_natlist L)),
	interp (ord_bad L),
	interp (ins N L O),
	not (interp (ord_bad O)).

cex_prog_1 E T :-
	check (qgen (qheight 4)) (is_exp E),
	check (qgen (qheight 1)) (is_ty T),
	interp (wt null E T),
	not (interp (progress E)).

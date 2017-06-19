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

prog (is_nat zero) (tt).
prog (is_nat (succ N)) (is_nat N).

prog (is_natlist null) (tt).
prog (is_natlist (cons Hd Tl)) (and (is_nat Hd) (is_natlist Tl)).

prog (is_exp error) (tt).
prog (is_exp (lam E)) (nabla (x\ is_exp (E x))).

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

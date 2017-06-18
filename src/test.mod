module test.

% Interpreter

interp (l\ tt).

interp (l\ and (G1 l) (G2 l)) :-
	interp G1,
	interp G2.

interp (l\ or (G1 l) (G2 l)) :-
	interp G1;
	interp G2.

interp (l\ all (x\ G x l)) :-
	interp (l\ G (fst l) (rst l)).

interp (l\ A l) :-
	(pi l\ prog (A l) (G l)),
	interp G.

% Checker

check Cert (l\ tt) :-
	tt_expert Cert.

check Cert (l\ or (G1 l) (G2 l)) :-
	or_expert Cert Cert' Choice,
	(
		(Choice = left, check Cert' G1)
	;
		(Choice = right, check Cert' G2)
	).

check Cert (l\ and (G1 l) (G2 l)) :-
	and_expert Cert Cert1 Cert2,
	check Cert1 G1,
	check Cert2 G2.

check Cert (l\ A l) :-
	prog_expert Cert Cert',
	(pi l\ prog (A l) (G l)),
	check Cert' G.

% Program

prog (is_nat zero) (tt).
prog (is_nat (succ N)) (is_nat N).

prog (is_natlist null) (tt).
prog (is_natlist (cons Hd Tl)) (and (is_nat Hd) (is_natlist Tl)).

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

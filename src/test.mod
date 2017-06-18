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

% Program
prog (is_nat zero) (tt).
prog (is_nat (succ N)) (is_nat N).

module kernel.

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

prog (append null K K) (tt).
prog (append (cons X L) K (cons X M)) (append L K M).

% "Quick"-style FPC

tt_expert (qgen (qheight _)).
tt_expert (qgen (qsize In In)).

and_expert (qgen (qheight H)) (qgen (qheight H)) (qgen (qheight H)).
and_expert (qgen (qsize In Out)) (qgen (qsize In Mid)) (qgen (qsize Mid Out)).

prog_expert (qgen (qheight H)) (qgen (qheight H')) :-
	H > 0,
	H' is H - 1.
prog_expert (qgen (qsize In Out)) (qgen (qsize In' Out)) :-
	In > 0,
	In' is In - 1.

% Certificate pairing

tt_expert (pair C1 C2) :-
	tt_expert C1,
	tt_expert C2.

and_expert (pair C1 C2) (pair C1' C2') (pair C1'' C2'') :-
	and_expert C1 C1' C1'',
	and_expert C2 C2' C2''.

prog_expert (pair C1 C2) (pair C1' C2') :-
	prog_expert C1 C1',
	prog_expert C2 C2'.

% Tests
cex_ord_bad N L :-
	check (qgen (qheight 4)) (and (is_nat N) (is_natlist L)),
	interp (ord_bad L),
	interp (ins N L O),
	not (interp (ord_bad O)).

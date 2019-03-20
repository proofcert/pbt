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

%% Strict bounds

tt_expert (qgen (qidsize _)).
and_expert (qgen (qidsize Max)) Cert Cert' :-
	and_expert (qgen (qidsize' 0 Max)) Cert Cert'.
prog_expert (qgen (qidsize Max)) Cert :-
	prog_expert (qgen (qidsize' 0 Max)) Cert.

tt_expert (qgen (qidsize' _ _)).
and_expert (qgen (qidsize' Size Max)) Cert Cert' :-
	Size < Max,
	Size' is Size + 1,
	and_expert (qgen (qrgsize Size' 0)) Cert Cert'.
prog_expert (qgen (qidsize' Size Max)) Cert :-
	Size < Max,
	Size' is Size + 1,
	prog_expert (qgen (qrgsize Size' 0)) Cert.
and_expert (qgen (qidsize' Size Max)) Cert Cert' :-
	Size < Max,
	Size' is Size + 1,
	and_expert (qgen (qidsize' Size' Max)) Cert Cert'.
prog_expert (qgen (qidsize' Size Max)) Cert :-
	Size < Max,
	Size' is Size + 1,
	prog_expert (qgen (qidsize' Size' Max)) Cert.

tt_expert (qgen (qrgsize Mid Mid)).
and_expert (qgen (qrgsize Max Min)) (qgen (qrgsize Max Mid)) (qgen (qrgsize Mid Min)).
prog_expert (qgen (qrgsize Max Min)) (qgen (qrgsize Max' Min)) :-
	Max > 0,
	Max' is Max - 1.

%% Similarly for height. Exact bounds are inefficient in that there is no
%% immediate *and* simple way to cooordinate both sides of a conjunct so that at
%% least one reaches the required height. An easy workaround leads to some
%% duplication, which may be curbed by pairing with a size bound that drives
%% generation. The coordination of the increase in both kinds of bounds is also
%% a subject of further elaboration.

tt_expert (qgen (qidheight _)).
and_expert (qgen (qidheight Max)) Cert Cert' :-
	and_expert (qgen (qidheight' 0 Max)) Cert Cert'.
prog_expert (qgen (qidheight Max)) Cert :-
	prog_expert (qgen (qidheight' 0 Max)) Cert.

tt_expert (qgen (qidheight' _ _)).
and_expert (qgen (qidheight' Size Max)) Cert Cert' :-
	Size < Max,
	Size' is Size + 1,
	and_expert (qgen (qrgheight Size' 0)) Cert Cert'.
prog_expert (qgen (qidheight' Size Max)) Cert :-
	Size < Max,
	Size' is Size + 1,
	prog_expert (qgen (qrgheight Size' 0)) Cert.
and_expert (qgen (qidheight' Size Max)) Cert Cert' :-
	Size < Max,
	Size' is Size + 1,
	and_expert (qgen (qidheight' Size' Max)) Cert Cert'.
prog_expert (qgen (qidheight' Size Max)) Cert :-
	Size < Max,
	Size' is Size + 1,
	prog_expert (qgen (qidheight' Size' Max)) Cert.

tt_expert (qgen (qrgheight Min Min)).
and_expert (qgen (qrgheight Max Min)) (qgen (qrgheight Max Min)) (qgen (qheight Max)).
and_expert (qgen (qrgheight Max Min)) (qgen (qheight Max)) (qgen (qrgheight Max Min)).
prog_expert (qgen (qrgheight Max Min)) (qgen (qrgheight Max' Min)) :-
	Max > 0,
	Max' is Max - 1.

min A B A :-
	A <= B.
min A B B :-
	A > B.

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

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

interp (eq G G).

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

% (At the moment, as with nabla, no eq_expert.)
check Cert (eq G G).

check Cert A :-
	unfold_expert Cert Cert',
	prog A G,
	check Cert' G.

% Program

%% Natural numbers

prog (is_nat N)
     (or (and (eq N zero)
              tt
         )
         (and (eq N (succ N'))
              (is_nat N')
         )
     ).

prog (leq X Y)
     (or (and (eq X zero)
              tt
         )
         (and (and (eq X (succ X')) (eq Y (succ Y')))
              (leq X' Y')
         )
     ).

prog (gt X Y)
     (or (and (and (eq X (succ _)) (eq Y zero))
              tt
         )
         (and (and (eq X (succ X')) (eq Y (succ Y')))
              (gt X' Y')
         )
     ).

%% Lists

prog (is_natlist L)
     (or (and (eq L null)
              tt
         )
         (and (eq L (cons Hd Tl))
              (and (is_nat Hd) (is_natlist Tl))
         )
     ).

prog (ord L)
     (or (and (eq L null)
              tt
         )
     (or (and (eq L (cons X null))
              (is_nat X)
         )
         (and (eq L (cons X (cons Y Rs)))
              (and (leq X Y) (ord (cons Y Rs)))
         )
     )).

prog (ord_bad L)
     (or (and (eq L null)
              tt
         )
     (or (and (eq L (cons X null))
              (is_nat X)
         )
         (and (eq L (cons X (cons Y Rs)))
              (and (leq X Y) (ord_bad Rs))
         )
     )).

prog (ins X L O)
     (or (and (and (eq L null) (eq O (cons X null)))
              (is_nat X)
         )
     (or (and (and (eq L (cons Y Ys)) (eq O (cons X (cons Y Ys))))
              (leq X Y)
         )
         (and (and (eq L (cons Y Ys)) (eq O (cons Y Rs)))
              (and (gt X Y) (ins X Ys Rs))
         )
     )).

prog (append L1 K L2)
     (or (and (and (eq L1 null) (eq K L2))
              tt
         )
         (and (and (eq L1 (cons X L)) (eq L2 (cons X M)))
              (append L K M)
         )
     ).

% "Quick"-style FPC

tt_expert (qgen (qheight _)).
tt_expert (qgen (qsize In In)).

and_expert (qgen (qheight H)) (qgen (qheight H)) (qgen (qheight H)).
and_expert (qgen (qsize In Out)) (qgen (qsize In Mid)) (qgen (qsize Mid Out)).

or_expert (qgen (qheight H)) (qgen (qheight H)) Ch.
or_expert (qgen (qsize In Out)) (qgen (qsize In Out)) Ch.

unfold_expert (qgen (qheight H)) (qgen (qheight H')) :-
	H > 0,
	H' is H - 1.
unfold_expert (qgen (qsize In Out)) (qgen (qsize In' Out)) :-
	In > 0,
	In' is In - 1.

% Randomized "quick"-style FPC

tt_expert qrandom.

and_expert qrandom qrandom qrandom.

or_expert qrandom qrandom Choice :-
	print "Toss a coin \"0.\" or \"1.\": ",
        read Random,
	(
		(Random = 0, Choice = left);
		(Random = 1, Choice = right)
	).

unfold_expert qrandom qrandom.

% Certificate pairing

tt_expert (pair C1 C2) :-
	tt_expert C1,
	tt_expert C2.

and_expert (pair C1 C2) (pair C1' C2') (pair C1'' C2'') :-
	and_expert C1 C1' C1'',
	and_expert C2 C2' C2''.

or_expert (pair C1 C2) (pair C1' C2') Ch :-
	or_expert C1 C1' Ch,
	or_expert C2 C2' Ch.

unfold_expert (pair C1 C2) (pair C1' C2') :-
	unfold_expert C1 C1',
	unfold_expert C2 C2'.

% Tests
cex_ord_bad N L :-
	check (qgen (qheight 4)) (and (is_nat N) (is_natlist L)),
	interp (ord_bad L),
	interp (ins N L O),
	not (interp (ord_bad O)).

% N = zero
%     0
% L = [zero, succ zero, zero | null]
%     1, 0,
%     1, 1, 0,
%     1, 0,
%     0
cex_ord_bad_random N L :-
	check qrandom (and (is_nat N) (is_natlist L)),
	term_to_string N NStr, term_to_string L LStr,
	print NStr, print ", ", print LStr, print "\n",
	interp (ord_bad L),
	interp (ins N L O),
	not (interp (ord_bad O)).

main :-
	cex_ord_bad_random N L.

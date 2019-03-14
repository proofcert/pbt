module kernel.

%%%%%%%%%%%%%%%%%%%%%
% Helper predicates %
%%%%%%%%%%%%%%%%%%%%%

memb X (X :: L).
memb X (Y :: L) :- memb X L.

member X (X :: L) :- !.
member X (Y :: L) :- member X L.

%%%%%%%%%%%%%%%
% Interpreter %
%%%%%%%%%%%%%%%

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
interp A :-
	progs A Gs,
	memb (np _ G) Gs,
	interp G.

%%%%%%%%%%%
% Checker %
%%%%%%%%%%%

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

% At the moment, as with nabla, no eq_expert.
check Cert (eq G G).

% The unfold rule lets the expert inspect the available clauses (this should
% be done with great care, ideally limiting the information to a list of names,
% set and immutable) and can restrict their selection by name.
check Cert A :-
	progs A Gs,
% term_to_string Gs GsStr, print "unfold to select:", print GsStr,
	unfold_expert Gs Cert Cert' Id,
	memb (np Id G) Gs,
% term_to_string G GStr, print "unfold selected: ", print Id, print ", ", print GStr,
	check Cert' G.

%%%%%%%%%%%
% Program %
%%%%%%%%%%%

%% Natural numbers

progs (is_nat N)
      [(np "n_zero" (eq N zero)),
       (np "n_succ" (and (eq N (succ N'))
                         (is_nat N')))].

%TODO: Check Elpi bug
progs (leq X Y)
      [(np "leq_zero" (eq X zero)),
       (np "leq_succ" (and (and (eq X (succ X')) (eq Y (succ Y')))
                           (leq X' Y'))) ].

progs (gt X Y)
      [(np "gt_zero" (and (eq X (succ _)) (eq Y zero))),
       (np "gt_succ" (and (and (eq X (succ X')) (eq Y (succ Y')))
                          (gt X' Y'))) ].

%% Lists

progs (is_natlist L)
      [(np "nl_null" (eq L null)),
       (np "nl_cons" (and (eq L (cons Hd Tl))
                     (and (is_nat Hd) (is_natlist Tl)))) ].

progs (ord L)
      [(np "ord0" (eq L null)),
       (np "ord1" (and (eq L (cons X null))
                       (is_nat X))),
       (np "ord2" (and (eq L (cons X (cons Y Rs)))
                       (and (leq X Y) (ord (cons Y Rs))))) ].

progs (ord_bad L)
      [(np "ord0_bad" (eq L null)),
       (np "ord1_bad" (and (eq L (cons X null))
                           (is_nat X))),
       (np "ord2_bad" (and (eq L (cons X (cons Y Rs)))
                           (and (leq X Y) (ord_bad Rs)))) ].

progs (ins X L O)
      [(np "ins_null" (and (and (eq L null) (eq O (cons X null)))
                           (is_nat X))),
       (np "ins_leq"  (and (and (eq L (cons Y Ys)) (eq O (cons X (cons Y Ys))))
                           (leq X Y))),
       (np "ins_gt"   (and (and (eq L (cons Y Ys)) (eq O (cons Y Rs)))
                           (and (gt X Y) (ins X Ys Rs)))) ].

progs (append L1 K L2)
      [(np "app_null" (and (eq L1 null) (eq K L2))),
       (np "app_cons" (and (and (eq L1 (cons X L)) (eq L2 (cons X M)))
                           (append L K M))) ].

%%%%%%%%%%%%%%%%%%%%%
% "Quick"-style FPC %
%%%%%%%%%%%%%%%%%%%%%

tt_expert (qgen (qheight _)).
tt_expert (qgen (qsize In In)).

and_expert (qgen (qheight H)) (qgen (qheight H)) (qgen (qheight H)).
and_expert (qgen (qsize In Out)) (qgen (qsize In Mid)) (qgen (qsize Mid Out)).

or_expert (qgen (qheight H)) (qgen (qheight H)) Ch.
or_expert (qgen (qsize In Out)) (qgen (qsize In Out)) Ch.

unfold_expert _ (qgen (qheight H)) (qgen (qheight H')) _ :-
	H > 0,
	H' is H - 1.
unfold_expert _ (qgen (qsize In Out)) (qgen (qsize In' Out)) _ :-
	In > 0,
	In' is In - 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Randomized "quick"-style FPC %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Helper predicates

% For each possible named clause that can be selected, find its weight in the
% table of generators (currently assuming the tables are exhaustive). Return the
% sum of weights as well as the subset of rows in the table of generators
% corresponding to the set of selectable clauses. In the second return argument,
% the order of the rows matches their appearance in the full table of generators
% (and in a first approximation, this is not done tail recursively).
sum_weights [] _ 0 [].
sum_weights ((np ClauseId _) :: Clauses) Weights Sum CleanWeights :-
	% Assume a matching tuple is always present
	member (qw ClauseId Weight) Weights,
	sum_weights Clauses Weights SubTotal SubWeights,
	Sum is SubTotal + Weight,
	CleanWeights = (qw ClauseId Weight) :: SubWeights.

% Take a lost of weighed clauses summing up to N = N1, N2, ... Nk; and a number
% in the range [0, N). Select the clause according to the distribution:
%   0 .. N1 - 1
%   N1 .. (N2 - N1 - 1)
%   ...
select_clause Countdown ((qw ClauseId Weight) :: _) ClauseId :-
	Countdown < Weight.
select_clause Countdown ((qw _ Weight) :: Weights) ClauseId :-
	Countdown >= Weight,
	Countdown' is Countdown - Weight,
	select_clause Countdown' Weights ClauseId.

%% Random generation of data

tt_expert (qrandom _).

and_expert (qrandom Ws) (qrandom Ws) (qrandom Ws).

or_expert (qrandom Ws) (qrandom Ws) Choice :-
	(
		Choice = left;
		Choice = right
	).

unfold_expert Gs (qrandom Ws) (qrandom Ws) Id :-
	sum_weights Gs Ws Sum SubWs,
	term_to_string Sum SumStr,
	Msg is "Select a number [0-" ^ SumStr ^ "):",
	print Msg,
	read Random,
	select_clause Random SubWs Id,
	print Id.

%% Iteration on number of tries (somewhat redundant encoding)

and_expert (qtries N W) (qrandom W) (qrandom W) :-
	N > 0.
and_expert (qtries N W) Cert Cert' :-
	N > 0,
	N' is N - 1,
% print "Retrying",
	and_expert (qtries N' W) Cert Cert'.

unfold_expert Gs (qtries N W) Cert Id :-
	N > 0,
	unfold_expert Gs (qrandom W) Cert Id.
unfold_expert Gs (qtries N W) Cert Id :-
	N > 0,
	N' is N - 1,
% print "Retrying",
	unfold_expert Gs (qtries N' W) Cert Id.

%% Certificate pairing

tt_expert (pair C1 C2) :-
	tt_expert C1,
	tt_expert C2.

and_expert (pair C1 C2) (pair C1' C2') (pair C1'' C2'') :-
	and_expert C1 C1' C1'',
	and_expert C2 C2' C2''.

or_expert (pair C1 C2) (pair C1' C2') Ch :-
	or_expert C1 C1' Ch,
	or_expert C2 C2' Ch.

unfold_expert Gs (pair C1 C2) (pair C1' C2') Id :-
	unfold_expert Gs C1 C1' Id,
	unfold_expert Gs C2 C2' Id.

%%%%%%%%%
% Tests %
%%%%%%%%%

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
	Ws = [(qw "n_zero" 1), (qw "n_succ" 1),
              (qw "nl_null" 1), (qw "nl_cons" 1)],
	check (qtries 2 Ws) (and (is_nat N) (is_natlist L)),
	term_to_string N NStr, term_to_string L LStr,
	print NStr, print ", ", print LStr,
	interp (ord_bad L),
	interp (ins N L O),
	not (interp (ord_bad O)).

main :-
	cex_ord_bad_random N L.

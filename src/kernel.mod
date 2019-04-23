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

check Cert (some G) :-
	some_expert Cert Cert' T,
	check Cert' (G T).

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




%%%%%%%%%%%%%%%%%%%%%
% Exhaustive enumeration FPC %
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

%% Existential expert

some_expert (qgen Bound) (qgen Bound) T.


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
and_expert (qgen (qrgheight Max Min)) (qgen (qrgheight Max Min)) (qgen (qrgheight Max Min)).
and_expert (qgen (qrgheight Max Min)) (qgen (qrgheight Max Min)) (qgen (qheight Max')) :-
	Max > 0,
	Max' is Max - 1.
and_expert (qgen (qrgheight Max Min)) (qgen (qheight Max')) (qgen (qrgheight Max Min)) :-
	Max > 0,
	Max' is Max - 1.
prog_expert (qgen (qrgheight Max Min)) (qgen (qrgheight Max' Min)) :-
	Max > 0,
	Max' is Max - 1.


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

% only for elpi
unfold_expert Gs (qrandom Ws) (qrandom Ws) Id :-
	sum_weights Gs Ws Sum SubWs,
%	term_to_string Sum SumStr,
%	Msg is "Select a number [0-" ^ SumStr ^ "):",
%	print Msg,
%%	read Random,
	random.int Sum Random,
%	term_to_string Random RandomStr,
%	print Random,
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

%% Existential expert

some_expert (qtries N W) (qtries N W) T.
some_expert (qrandom W) (qrandom W) T.

%%%%%%%%%%%%%
% Shrinking %
%%%%%%%%%%%%%

tt_expert qcompute.

and_expert qcompute qcompute qcompute.

or_expert qcompute qcompute Choice :-
	(
		Choice = left;
		Choice = right
	).

unfold_expert _Gs qcompute qcompute _Id.

some_expert (qshrink T Cert) Cert T.
some_expert (qshrink T Cert) Cert T' :-
	shrink T T'.

%%%%%%%%%%%%%%%%%%%%%%%
% Certificate pairing %
%%%%%%%%%%%%%%%%%%%%%%%

tt_expert (pair C1 C2) :-
	tt_expert C1,
	tt_expert C2.

and_expert (pair C1 C2) (pair C1' C2') (pair C1'' C2'') :-
	and_expert C1 C1' C1'',
	and_expert C2 C2' C2''.

or_expert (pair C1 C2) (pair C1' C2') Ch :-
	or_expert C1 C1' Ch,
	or_expert C2 C2' Ch.

some_expert (pair C1 C2) (pair C1' C2') T :-
	some_expert C1 C1' T,
	some_expert C2 C2' T.

unfold_expert Gs (pair C1 C2) (pair C1' C2') Id :-
	unfold_expert Gs C1 C1' Id,
	unfold_expert Gs C2 C2' Id.


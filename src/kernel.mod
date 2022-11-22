module kernel.

%%%%%%%%%%%%%%%%%%%%%
% Helper predicates %
%%%%%%%%%%%%%%%%%%%%%

memb X (X :: L).
memb X (Y :: L) :- memb X L.

%%%%%%%%%%%%%%%
% Interpreter %
%%%%%%%%%%%%%%%

interp true.
interp (G, H) :- interp G, interp H.
interp (G; H) :- interp G; interp H.
interp (sigma G) :- interp (G T).
interp (pi G) :- pi x\ interp (G x).
interp A :- (A <>= G), interp G.

%%%%%%%%%%%
% Checker %
%%%%%%%%%%%

check Cert true :-
	tt_expert Cert.
check Cert (G = G) :-
	eq_expert Cert.
check Cert (G1, G2) :-
	and_expert Cert Cert1 Cert2,
	check Cert1 G1,
	check Cert2 G2.

check Cert (G1; G2) :-
	or_expert Cert Cert' Choice,
	(
		(Choice = left, check Cert' G1)
	;
		(Choice = right, check Cert' G2)
	).

check Cert (sigma G) :-
	some_expert Cert Cert' T,
	check Cert' (G T).

check Cert (pi G) :-
	pi x\ check Cert (G x).

/*
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
%
*/
check Cert A :-
	(A <>= G),
	unfold_expert Cert Cert',
	check Cert' G.

/*interp tt.

interp (and G1 G2) :-
	interp G1,
	interp G2.

interp (or G1 G2) :-
	interp G1;
	interp G2.

interp (some G) :-
	interp (G _).

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
*/

module test-lst.
accumulate lst. 

%%%%%%%%%
% Tests %
%%%%%%%%%

% no of tries
tries 100.

cex_ord_bad N L :-
	check (qgen (qheight 4)) (and (is_nat N) (is_natlist L)),
	interp (ord_bad L),
	interp (ins N L O),
	not (interp (ord_bad O)).


cex_ord_bad2 N1 N2 L :-
	check (qgen (qheight 4)) (and (is_nat N1) (and (is_nat N2) (is_natlist L))),
	interp (ord_bad (cons N2 L)),
	interp (leq N1 N2),
	not (interp (ord_bad (cons N1 (cons N2 L)))).

% N = zero
%     0
% L = [zero, succ zero, zero | null]
%     1, 0,
%     1, 1, 0,
%     1, 0,
%     0
cex_ord_bad_random N L :-
	Ws = [(qw "n_zero" 1), (qw "n_succ" 2),
              (qw "nl_null" 1), (qw "nl_cons" 2)],
	      tries NT,
	check (qtries NT Ws) (and (is_nat N) (is_natlist L)),
	term_to_string N NStr, term_to_string L LStr,
	print NStr, print " and list: ", print LStr,
	interp (ord_bad L),
	interp (ins N L O),
	not (interp (ord_bad O)).


cex_ord_bad_random2 N1 N2 L :-
	Ws = [(qw "n_zero" 1), (qw "n_succ" 2),
              (qw "nl_null" 1), (qw "nl_cons" 3)],
	      tries NT,
	check (qtries NT Ws) (and (is_nat N1) (and (is_nat N2) (is_natlist L))),
	term_to_string N1 NStr1, term_to_string N2 NStr2, term_to_string L LStr,
	print NStr1, print ", ", print NStr2, print ", ", print LStr,
	interp (ord_bad (cons N2 L)),
	interp (leq N1 N2),
	not (interp (ord_bad (cons N1 (cons N2 L)))).

% the property is true
nocex_rev_random  L :-
	Ws = [(qw "nl_null" 1), (qw "nl_cons" 3)],
	      tries NT,
	check (qtries NT Ws) ((is_natlist L)),
	term_to_string L LStr,
	print "list: ", print LStr,
	interp (rev L R),
	not (interp (rev R L)).

nocex_rev  L :-
	check (qgen (qheight 6)) ( (is_natlist L)),
	interp (rev L R),
	not (interp (rev R L)).






% main :-
%      read G,
%      G.

main  :-
	cex_ord_bad_random _N _L.
main2  :-
	cex_ord_bad_random2  _N1 _N2 _L.

main1 :-
      nocex_rev_random _L.
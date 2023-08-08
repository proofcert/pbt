module test-lst.
accumulate random.
accumulate interp.
accumulate kernel.
accumulate fpcs.

%%%%%%%%%
% Tests %
%%%%%%%%%

%% hello world: rv is involutive
nocex_rev  Gen L :-
	   	   check Gen (nlist L), 
		   interp (reverse L R),
		   not (interp (reverse R L)).

%% our beloved example: reverse is not the id function
cex_rev Gen L :-
	check Gen (nlist L),
%	spy(
	interp (reverse L R)
%	)
	,
	not (L = R).

cex_rev_test O L :-
  open_oracle O (iterate 10, cex_rev noweight L).

% this must fail
cex_rev_test_sym  O L :-
  open_oracle O ((iterate 10), nocex_rev noweight L).


% insertion
cex_ord_bad Gen N L :-
	check Gen ((nat N) and (nlist L)),
	interp (ord_bad L),
% 	check Gen (ord_bad L),
	interp (ins N L O),
	not (interp (ord_bad O)).

cex_ord_test_r  O N L :-
  open_oracle O ((iterate 10), cex_ord_bad noweight N L).



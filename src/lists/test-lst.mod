module test-lst.
accumulate nat.
accumulate lst.
accumulate kernel.
accumulate fpc-qbound.
accumulate fpc-qshrink.
accumulate fpc-pair.

%%%%%%%%%
% Tests %
%%%%%%%%%


% Simple generators, explicit existentials
check_ord_bad N L Cert :-
	check Cert
              (some N'\ some L'\ and (and (eq N N') (eq L L'))
                                     (and (is_nat N') (is_natlist L'))),
	interp (ord_bad L),
	interp (ins N L O),
	not (interp (ord_bad O)).

cex_ord_bad N L :-
	%check (qgen (qheight 4)) (and (is_nat N) (is_natlist L)),
	%interp (ord_bad L),
	check (qgen (qheight 4)) (ord_bad L),
	interp (ins N L O),
	not (interp (ord_bad O)).


cex_ord_bad2 N1 N2 L :-
	check (qgen (qheight 4)) (and (is_nat N1) (and (is_nat N2) (is_natlist L))),
	interp (ord_bad (cons N2 L)),
	interp (leq N1 N2),
	not (interp (ord_bad (cons N1 (cons N2 L)))).



% Currently two levels of backtracking: cex finding and shrinking over those.
cex_ord_bad_shrink Nbig Lbig Nsmall Lsmall :-
	check_ord_bad Nbig Lbig (pair (qgen (qheight 6)) (qsubst Qsubst)),
	subst2shrink Qsubst Qshrink,
	check_ord_bad Nsmall Lsmall Qshrink.

%%% reverse


%% hello world
nocex_rev  L :-
	check (qgen (qheight 6)) ( (is_natlist L)),
	interp (rev L R),
	not (interp (rev R L)).

%% our beloved example
cex_rev Gen L :-
	check Gen (is_natlist L),
	interp (rev L R),
	not (L = R).







module cr.

% [harness] ?- prop_dia (height 4) beta M.
%
% The answer substitution:
% M = app (lam (W1\ app W1 W1)) (app (lam (W1\ W1)) (lam (W1\ W1)))
%
% More solutions (y/n)? y
%
% The answer substitution:
% M = app (lam (W1\ app W1 W1)) (app (lam (W1\ W1)) (lam (W1\ W1)))
%
% More solutions (y/n)? 

/* joinable */
joinableS Step M M    <>== tt.
joinableS Step M1 M2  <>== some P\ (Step M1 P) and (Step M2 P).

prop_dia Cert Step M :-
    llcheck Cert nil nil (is_exp M),
    llinterp nil nil (Step M M1),
    llinterp nil nil (Step M M2),
    not(llinterp nil nil (joinableS Step M1 M2)).
/* end */

% [harness] ?- prop_eta_pres (height 4) M M' A.
%
% The answer substitution:
% A = arTy _T1 (arTy unitTy (arTy _T2 unitTy))
% M' = app (app (lam (W1\ W1)) (lam (W1\ W1))) (lam (W1\ lam (W2\ ep)))
% M = app (app (lam (W1\ W1)) (lam (W1\ W1))) (lam (W1\ lam (W2\ W1)))
%
% More solutions (y/n)? y
%
% The answer substitution:
% A = arTy _T1 (arTy unitTy (arTy _T2 unitTy))
% M' = app (lam (W1\ W1)) (lam (W1\ lam (W2\ ep)))
% M = app (lam (W1\ W1)) (lam (W1\ lam (W2\ W1)))
%
% More solutions (y/n)? 

/* eta-cex */
wt_pres M N A <>== (wt M A) and (wt N A).

prop_eta_pres Gen M M' A:-
    llcheck Gen nil nil (is_exp M),
    llinterp nil nil (teta M M' A),
    not(llinterp nil nil (wt_pres M M' A)).
/* end */

/* wt */
wt ep unitTy          <>== tt.
wt (lam M) (arTy A B) <>== all x\ wt x A =o wt (M x) B.
wt (app M N) B        <>== some A\ wt M (arTy A B) and wt N A.

teta (lam x\ app M x) M (arTy A B)  <>== wt M (arTy A B).
teta M ep unitTy                    <>== (wt M unitTy).
teta (app M N) (app M' N) B <>==
  some A\ (teta M M' (arTy A B)) and (wt N A).
teta (app M N) (app M N') B <>== 
  some A\ (teta N N' A) and (wt N (arTy A B)).
teta (lam M) (lam N) (arTy A B) <>== 
  all w\ wt w A =o teta (M w) (N w) B.
/* end */

beta (app (lam M) N) (M N)    <>== tt.
beta (app N1 N2) (app N11 N2) <>== beta N1 N11.
beta (app N1 N2) (app N1 N22) <>== beta N2 N22.
beta (lam M)     (lam N)      <>== all x\ beta (M x) (N x).
  
is_exp (app E1 E2) <>== is_exp E1 and is_exp E2.
is_exp (lam E)     <>== all x\ is_exp x =o is_exp (E x).

is_ty unitTy <>== tt.
is_ty (arTy A B) <>== (is_ty A) and (is_ty B).

example 1 (app (app (lam (W1\ W1)) (lam (W1\ W1))) (lam (W1\ lam (W2\ W1)))).
example 2 (app (app (lam (W1\ W1)) (lam (W1\ W1))) (lam (W1\ lam (W2\ ep)))).

% ?- example 1 M, example 2 N, eta_pres (height 5) M N (arTy unitTy (arTy _T1 unitTy)).
% This fail, meaning that M and N can both have this type.
%
% ?- example 1 M, example 2 N, eta_pres (height 5) M N (arTy A (arTy unitTy (arTy B unitTy))).
% This succeeds, meaning that M and N cannot both have this type.

% [harness] ?- prop_eta_dia (height 4)  M A.
%
% The answer substitution:
% A = arTy (arTy unitTy unitTy) (arTy unitTy unitTy)
% M = lam (W1\ lam (W2\ app W1 W2))
%
% More solutions (y/n)? y
%
% The answer substitution:
% A = arTy (arTy unitTy unitTy) (arTy unitTy unitTy)
% M = lam (W1\ lam (W2\ app W1 W2))
%
% More solutions (y/n)? y
%
% The answer substitution:
% A = arTy (arTy (arTy unitTy unitTy) unitTy) (arTy (arTy unitTy unitTy) unitTy)
% M = lam (W1\ lam (W2\ app W1 W2))
%
% More solutions (y/n)? y
%
% The answer substitution:
% A = arTy (arTy (arTy unitTy unitTy) unitTy) (arTy (arTy unitTy unitTy) unitTy)
% M = lam (W1\ lam (W2\ app W1 W2))
%
% More solutions (y/n)? y
%
% no (more) solutions
%
% [harness] ?- 

joinable_teta M M A    <>== tt.
joinable_teta M1 M2 A  <>== some P\ (teta M1 P A) and (teta M2 P A).
/* dia_teta */
prop_eta_dia Cert  M A :-
    llcheck Cert nil nil (wt M A and is_ty A),
    llinterp nil  nil (teta M M1 A),
    llinterp nil nil (teta M M2 A),
    not(llinterp nil nil (joinable_teta M1 M2 A)).

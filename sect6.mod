module sect6.

member X (X::_).
member X (_::L) :- member X L.

/* interp */
interp Ctx tt.
interp Ctx (T eq T).
interp Ctx (G1 and G2) :- interp Ctx G1, interp Ctx G2.
interp Ctx (G1 or G2)  :- interp Ctx G1; interp Ctx G2.
interp Ctx (some G)    :- interp Ctx (G T).
interp Ctx (A =o G)    :- interp (A::Ctx) G.
interp Ctx (all G)     :- pi x\ interp Ctx (G x).
interp Ctx A           :- member A Ctx; 
                          (A <>== G), interp Ctx G.
/* end */

/* check */
check Cert Ctx tt          :- ttE Cert.
check Cert Ctx (T eq T)    :- eqE Cert.
check Cert Ctx (G1 and G2) :- andE Cert Cert1 Cert2,
                              check Cert1 Ctx G1,
                              check Cert2 Ctx G2.
check Cert Ctx (G1 or G2)  :- orE Cert Cert' LR, 
                              ((LR = left,  check Cert' Ctx G1);
                               (LR = right, check Cert' Ctx G2)).
check Cert Ctx (some G)    :- someE Cert Cert1 T, 
                              check Cert1 Ctx (G T).
check Cert Gamma (D =o G ) :- impC Cert Cert',
                              check Cert' (D::Gamma) G.
check Cert Gamma (all G)   :- allC Cert Cert',
                              pi x\ check (Cert' x) Gamma (G x).
check Cert Ctx A           :- initE Cert, member A Ctx.
check Cert Ctx A           :- backchainE Cert Cert', 
                              (A <>== G), check Cert' Ctx G.
/* end */

/* beta */
beta (app (lam M) N) (M N)    <>== tt.
beta (app N1 N2) (app N11 N2) <>== beta N1 N11.
beta (app N1 N2) (app N1 N22) <>== beta N2 N22.
beta (lam M)     (lam N)      <>== all x\ beta (M x) (N x).
  
is_exp (app E1 E2) <>== is_exp E1 and is_exp E2.
is_exp (lam E)     <>== all x\ is_exp x =o is_exp (E x).
/* end */

/* joinable */
joinable Step M M    <>== tt.
joinable Step M1 M2  <>== some P\ (Step M1 P) and (Step M2 P).

prop_dia Cert Step M :-
    check Cert nil (is_exp M),
    interp nil (Step M M1),
    interp nil (Step M M2),
    not(interp nil (joinable Step M1 M2)).
/* end */

is_ty unitTy <>== tt.
is_ty (arTy A B) <>== (is_ty A) and (is_ty B).
/* eta-cex */
wt_pres M N A <>== (wt M A) and (wt N A).

prop_eta_pres Gen M M' A:-
    check Gen nil (is_exp M),
    interp nil (teta M M' A),
    interp nil (is_ty A),  % to ground before NAF
    not(interp nil (wt_pres M N A)).
/* end */

/* wt */
wt unit unitTy        <>== tt.
wt (lam M) (arTy A B) <>== all x\ wt x A =o wt (M x) B.
wt (app M N) B        <>== some A\ wt M (arTy A B) and wt N A.

teta (lam x\ app M x) M (arTy A B)  <>== wt M (arTy A B).
teta M unit unitTy                    <>== (wt M unitTy).
teta (app M N) (app M' N) B <>==
   some A\ (teta M M' (arTy A B)) and (wt N A).
teta (app M N) (app M N') B <>== 
  some A\ (teta N N' A) and (wt M (arTy A B)).
teta (lam M) (lam N) (arTy A B) <>== 
  all w\ wt w A =o teta (M w) (N w) B.
/* end */

% teta (app M N) (app M' N) B <>==
 % some A\ (teta M M' (arTy A B)). % intentional bug: replace this clause with above to get cex


% Some fpcs
ttE     (height _).
eqE     (height _).
orE     (height H) (height H) _.
someE   (height H) (height H) _.
andE    (height H) (height H) (height H).
backchainE (height H) (height H') :- H  > 0, H' is H  - 1.

ttE     (sze In In).
eqE     (sze In In).
orE     (sze In Out) (sze In Out) _.
someE   (sze In Out) (sze In Out) _.
andE    (sze In Out) (sze In Mid) (sze Mid Out).
backchainE (sze In Out) (sze In' Out) :- In > 0, In' is In - 1.

ttE     (max empty).
eqE     (max empty).
orE     (max (choose C M)) (max M) C.
someE   (max (term   T M)) (max M) T.
andE    (max (binary M N)) (max M) (max N).
backchainE (max M) (max M).

ttE     (A <c> B) :- ttE A, ttE B.
eqE     (A <c> B) :- eqE A, eqE B.
someE   (A <c> B) (C <c> D) T         :- someE A C T, someE B D T.
orE     (A <c> B) (C <c> D) E         :- orE A C E, orE B D E. 
andE    (A <c> B) (C <c> D) (E <c> F) :- andE A C E, andE B D F. 
backchainE (A <c> B) (C <c> D)           :- backchainE A C, backchainE B D.

% Adding three additional predicates to these definitions
initE (height In) :- In > 0.
allC  (height In) (x\ height In).
impC  (height In) (height In).

initE (sze In In') :- In > 0, In' is In - 1.
allC  (sze In Out) (x\ sze In Out).
impC  (sze In Out) (sze In Out).

initE (max empty).
allC  (max (ab C)) (x\ max (C x)).
impC  (max C) (max C).

initE (A <c> B) :- initE A, initE B.
allC  (A <c> B) (x\ (C x) <c> (D x)) :- allC A C, allC B D.
impC  (A <c> B) (C <c> D) :- impC A C, impC B D.

% Tests:

% ?- prop_dia (height 4) beta M.
% The answer substitution:
% M = app (lam (W1\ app W1 W1)) (app (lam (W1\ W1)) (lam (W1\ W1)))

example 1 (app (app (lam (W1\ W1)) (lam (W1\ W1))) (lam (W1\ lam (W2\ W1)))).
example 2 (app (app (lam (W1\ W1)) (lam (W1\ W1))) (lam (W1\ lam (W2\ unit)))).

% ?- example 1 M, example 2 N, prop_eta_pres (height 5) M N (arTy unitTy (arTy _T1 unitTy)).
% This fail, meaning that M and N can both have this type.

% ?- example 1 M, example 2 N, prop_eta_pres (height 5) M N (arTy A (arTy unitTy (arTy B unitTy))).
% This succeeds, meaning that M and N cannot both have this type.


% cex to dia(teta)


joinable_teta M M A    <>== tt.
joinable_teta M1 M2 A  <>== some P\ (teta M1 P A) and (teta M2 P A).
/* dia_teta */
prop_eta_dia Cert  M A :-
    check Cert nil (wt M A and is_ty A),
    interp nil (teta M M1 A),
    interp nil (teta M M2 A),
    not(interp nil (joinable_teta M1 M2 A)).
/* end */    
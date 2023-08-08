module sect7.

/* llinterp */
llinterp In In  tt.
llinterp In In  (T eq T).
llinterp In Out (G1 and G2) :- llinterp In Mid G1,
                               llinterp Mid Out G2.
llinterp In Out (G1 or G2)  :- llinterp In Out G1;
                               llinterp In Out G2.
llinterp In Out (some G) :- llinterp In Out (G T).
llinterp In Out (all G)  :- pi x\ llinterp In Out (G x).
llinterp In In  (bang G) :- llinterp In In G.
llinterp In Out (A =o G) :- llinterp ((ubnd A)::In) 
                                     ((ubnd A)::Out) G.
llinterp In Out (A -o G) :- llinterp ((bnd A)::In) (del::Out) G.
llinterp In Out A        :- pick A In Out; 
                            (A <>== G), llinterp In Out G.

pick A (bnd A::L)  (del::L).
pick A (ubnd A::L) (ubnd A::L).
pick A (I::L)      (I::K) :- pick A L K.
/* end */

/* llcheck */
llcheck Cert In In  tt          :- ttE Cert.
llcheck Cert In In  (T eq T)    :- eqE Cert.
llcheck Cert In Out (G1 and G2) :- andE Cert Cert1 Cert2, 
                                 llcheck Cert1 In Mid G1, llcheck Cert2 Mid Out G2.
llcheck Cert In Out (G1 or G2)  :- orE Cert Cert' LR, 
                                ((LR = left,  llcheck Cert' In Out G1);
                                 (LR = right, llcheck Cert' In Out G2)).
llcheck Cert In Out (some G)    :- someE Cert Cert1 T, llcheck Cert In Out (G T).
llcheck Cert In Out (all G)     :- allC Cert Cert', 
                                 pi x\ llcheck (Cert' x) In Out (G x).
llcheck Cert In In  (bang G)    :- bangE Cert Cert', llcheck Cert' In In G.
llcheck Cert In Out (A =o G)    :- impC Cert Cert',
                                 llcheck Cert' ((ubnd A)::In) ((ubnd A)::Out) G.
llcheck Cert In Out (A -o G)    :- limpC Cert Cert',
                                 llcheck Cert ((bnd A)::In) (del::Out) G.
llcheck Cert In Out A           :- initE Cert, pick A In Out.
llcheck Cert In Out A           :- backchainE Cert Cert', 
                                (A <>== G), llcheck Cert' In Out G.
/* end */

beta (app (lam M) N) (M N)    <>== tt.
beta (app N1 N2) (app N11 N2) <>== beta N1 N11.
beta (app N1 N2) (app N1 N22) <>== beta N2 N22.
beta (lam M)     (lam N)      <>== all x\ beta (M x) (N x).
  
is_exp (app E1 E2) <>== is_exp E1 and is_exp E2.
is_exp (lam E)     <>== all x\ is_exp x =o is_exp (E x).

% linear expressions
/* is_lexp */
is_lexp (app E1 E2) <>== is_lexp E1 and is_lexp E2.
is_lexp (lam E)     <>== all x\ is_lexp x -o is_lexp (E x).
/* end */
is_lexp ep          <>== tt.
is_lexp (fst E)     <>== is_lexp E.
is_lexp (snd E)     <>== is_lexp E.
is_lexp (pair E F)  <>== is_lexp E and is_lexp F.


/* joinable */
joinableS Step M M    <>== tt.
joinableS Step M1 M2  <>== some P\ (Step M1 P) and (Step M2 P).

dia_cexS Cert Step M :-
    llcheck Cert nil nil (is_exp M),
    llinterp nil nil (Step M M1),
    llinterp nil nil (Step M M2),
    not(llinterp nil nil (joinableS Step M1 M2)).
/* end */

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

/* toggle */
toggle G <>== on  and (off -o G).
toggle G <>== off and (on  -o G).
/* end */

/* perm */
perm (X::L) K   <>== element X -o perm L K.
perm nil (X::K) <>== element X and perm nil K.
perm nil nil    <>== tt.
/* end */

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
limpC  (height In) (height In).

initE (sze In In') :- In > 0, In' is In - 1.
allC  (sze In Out) (x\ sze In Out).
impC  (sze In Out) (sze In Out).
limpC  (sze In Out) (sze In Out).

initE (max empty).
allC  (max (ab C)) (x\ max (C x)).
impC  (max C) (max C).
limpC  (max C) (max C).

initE (A <c> B) :- initE A, initE B.
allC  (A <c> B) (x\ (C x) <c> (D x)) :- allC A C, allC B D.
impC  (A <c> B) (C <c> D) :- impC A C, impC B D.
limpC  (A <c> B) (C <c> D) :- impC A C, impC B D.

% Tests:


example 1 (app (app (lam (W1\ W1)) (lam (W1\ W1))) (lam (W1\ lam (W2\ W1)))).
example 2 (app (app (lam (W1\ W1)) (lam (W1\ W1))) (lam (W1\ lam (W2\ ep)))).

% ?- example 1 M, example 2 N, eta_pres (height 5) M N (arTy unitTy (arTy _T1 unitTy)).
% This fail, meaning that M and N can both have this type.

% ?- example 1 M, example 2 N, eta_pres (height 5) M N (arTy A (arTy unitTy (arTy B unitTy))).
% This succeeds, meaning that M and N cannot both have this type.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stuff specific for Section 7.2: Operational semantics: lc with a counter
/* cbnv */
is_int (~ 1)  <>== tt.  %% some integers
is_int   0    <>== tt.
is_int  42    <>== tt.

value unit    <>== tt.
value (cst N) <>== tt.
value (lam M) <>== tt.

is_prog (cst C)     <>== is_int C.
is_prog get         <>== tt.
is_prog (set N)     <>== is_int N.
is_prog (app E1 E2) <>== is_prog E1 and is_prog E2.
is_prog (lam E)     <>== all x\ is_prog x =o is_prog (E x).

cbn V V           K <>== value V and K.
cbn get (cst C)   K <>== counter C and (counter C -o K).
cbn (set C) unit  K <>== counter D and (counter C -o K).
cbn (app E1 E2) V K <>== some R\ cbn E1 (lam R) (cbn (R E2) V K).

cbv V V           K <>== value V and K.
cbv get (cst C)   K <>== counter C and (counter C -o K).
cbv (set C) unit  K <>== counter D and (counter C -o K).
cbv (app E1 E2) V K <>== some R\ some U\ cbv E1 (lam R) 
                         (cbv E2 U (cbv (R U) V K)).
/* end */
top_level P I O I' O' :-  pi k\ llinterp I' O' k => llinterp I O (P k).

/* eval */
eval Pred M V :- 
 (pi k\ (pi I\ pi O\ llinterp I O k) =>
          (llinterp [bnd(counter 0)] _ (Pred M V k))).
/* end */

/* cex_cbnv */
prop_cbnv Cert M V U:-
  llcheck Cert nil nil (is_prog M),
  eval cbn M V, eval cbv M U, 
  not(llinterp nil nil (V eq U)).
/* end */


% Both program 2 and 5 distinquish cbv and cbn.
% ?- main cbv I V, main cbn I U, not (V = U).

prog 1 (get).
prog 2 (app (lam x\ get) (set 42)).
prog 3 (lam x\ x).
prog 4 (set 42).
prog 5 (app (app (lam x\ lam y\ y) (set 42)) get).

% pres1: Find linear lambda-terms that evaluation (via Step) to a 
% not linear term. None exist.

% pres2: Find terms that are not linear but evaluation (via Step)
% to a linear term.  The call to wt allows avoiding non terminating
% programs like (app (lam x\ app x x) (lam x\ app x x)).

/* pres */
prop_pres1 Cert Step M N :-
  llcheck Cert nil nil (is_lexp M),
  eval Step M V,
  not(llinterp nil nil (is_lexp V)).

prop_pres2 Cert Step M V :-
  llcheck Cert nil nil (is_exp M),
  not(llinterp nil nil (is_lexp M)),
  llinterp nil nil (wt M Ty),
  eval Step M V,
  llinterp nil nil (is_lexp V).
/* end */

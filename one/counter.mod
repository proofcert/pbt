module counter.

/* toggle */
toggle G <>== on  and (off -o G).
toggle G <>== off and (on  -o G).
/* end */

/* perm */
perm (X::L) K   <>== element X -o perm L K.
perm nil (X::K) <>== element X and perm nil K.
perm nil nil    <>== tt.
/* end */

% Stuff specific for Section 7.2: Operational semantics: lc with a counter
% linear expressions
/* is_lexp */
is_lexp (app E1 E2) <>== is_lexp E1 and is_lexp E2.
is_lexp (lam E)     <>== all x\ is_lexp x -o is_lexp (E x).
/* end */
is_lexp ep          <>== tt.
is_lexp (fst E)     <>== is_lexp E.
is_lexp (snd E)     <>== is_lexp E.
is_lexp (pair E F)  <>== is_lexp E and is_lexp F.


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
% ?- prog I M, eval cbn M V, eval cbv M U, not (U = V).

prog 1 (get).
prog 2 (app (lam x\ get) (set 42)).
prog 3 (lam x\ x).
prog 4 (set 42).
prog 5 (app (app (lam x\ lam y\ y) (set 42)) get).

% pres1: Find linear lambda-terms that evaluation (via Step) to a 
% not linear term. None exist.  For example, the following fails:
% ?- prog I M, prop_pres1 (height 5) cbn M V.

% pres2: Find terms that are not linear but evaluate (via Step)
% to a linear term.  The call to wt allows avoiding non-terminating
% programs like (app (lam x\ app x x) (lam x\ app x x)).  For example:
%
% ?- prop_pres2 ( height 4 ) cbv M V.
%
% The answer substitution:
% V = lam (W1\ W1)
% M = app (lam (W1\ lam (W2\ W2))) (app (lam (W1\ W1)) (lam (W1\ W1)))
%
% More solutions (y/n)? y
%
% The answer substitution:
% V = lam (W1\ W1)
% M = app (lam (W1\ lam (W2\ W2))) (lam (W1\ W1))
%
% More solutions (y/n)? 

/* pres */
prop_pres1 Cert Step M V :-
  llcheck Cert nil nil (is_lexp M),
  eval Step M V,
  not(llinterp nil nil (is_lexp V)).

prop_pres2 Cert Step M V :-
  llcheck Cert nil nil (is_prog M),
  not(llinterp nil nil (is_lexp M)),
  llinterp nil nil (wt M Ty),
  eval Step M V,
  llinterp nil nil (is_lexp V).
/* end */

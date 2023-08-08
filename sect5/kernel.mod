module kernel.

%check   A B       :- announce (check A B).

/* check */
% Certificate checker
type   check    cert -> sl -> o.

check Cert tt          :- ttE Cert.
check Cert (T eq T)    :- eqE Cert.
check Cert (G1 and G2) :- andE Cert Cert1 Cert2,
   check Cert1 G1, check Cert2 G2.
check Cert (G1 or G2) :- orE Cert Cert' LR, 
   ((LR = left,  check Cert' G1);
    (LR = right, check Cert' G2)).
check Cert (some G) :- someE Cert Cert1 T, check Cert1 (G T).
check Cert A :-
          backchainE  A Cert Cert', (A <>== G), check Cert' G.
/* end */

% /* checkx */
% check Cert A :- backchainEx A Cert Cert', (A <>== G), 
%                 check Cert' G.
% /* end */

/* nabla */
check Cert (all G) :-
      pi x\ check Cert (G x).

check Cert (nabla G) :-
      pi x\ check Cert (G x).
/* end */
/*
prog (is_nat zero) (tt).
prog (is_nat (succ N)) (is_nat N).
prog (is_natlist null) (tt).
prog (is_natlist (cons Hd Tl)) (and (is_nat Hd) (is_natlist Tl)).
*/

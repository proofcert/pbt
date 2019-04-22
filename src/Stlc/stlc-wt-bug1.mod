module stlc-wt-bug1.

% Bug 1
prog (wt Ga M A) (memb (bind M A) Ga).
prog (wt _ error _) (tt).
prog (wt _ (c M) T) (tcc M T).
prog (wt E (app M N) U) (and (wt E M (funTy T U)) (wt E N U)). % exists T
prog (wt Ga (lam F Tx) (funTy Tx T)) (nabla x\ wt (cons (bind x Tx) Ga) (F x) T).



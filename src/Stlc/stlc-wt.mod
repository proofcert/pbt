module stlc-wt.

prog (wt Ga M A) (memb_elt (bind M A) Ga).
prog (wt _ error _) (tt).
prog (wt _ (c M) T) (tcc M T).
prog (wt Ga (app X Y) T) (and (wt Ga X (funTy H T)) (wt Ga Y H)). % exists H
prog (wt Ga (lam F Tx) (funTy Tx T)) (nabla x\ wt (cons (bind x Tx) Ga) (F x) T).

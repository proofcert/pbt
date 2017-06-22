module cfg.

prog (is_ab a) (tt).
prog (is_ab b) (tt).

prog (is_ablist null) (tt).
prog (is_ablist (cons Hd Tl)) (and (is_ab Hd) (is_ablist Tl)).

prog (neq a b) (tt).
prog (neq b a) (tt).

prog (count _ null zero) (tt).
prog (count X (cons X Xs) (succ N)) (count X Xs N).
prog (count X (cons Y Xs) N) (and (neq X Y) (count X Xs N)).

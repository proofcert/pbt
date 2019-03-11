module cfg.

prog (is_ab AB)
     [(np "ab-a" (eq AB a)),
      (np "ab-b" (eq AB b)) ].

prog (is_ablist L)
     [(np "abl-null" (eq L null)),
      (np "abl-cons" (and (eq L (cons Hd Tl))
                          (and (is_ab Hd) (is_ablist Tl)))) ].

prog (neq X Y)
     [(np "neq-ab" (and (eq X a) (eq Y b))),
      (np "neq-ba" (and (eq X b) (eq Y a))) ].

prog (count X L N)
     [(np "count-zero" (and (eq L null) (eq N zero))),
      (np "count-succ" (and (and (eq L (cons X Xs)) (eq N (succ N')))
                            (count X Xs N'))),
      (np "count-neq"  (and (eq L (cons Y Xs))
                            (and (neq X Y) (count X Xs N)))) ].

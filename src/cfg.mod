module cfg.

prog (is_ab AB)
     (or (and (eq AB a)
              tt
         )
         (and (eq AB b)
              tt
         )
     ).

prog (is_ablist L)
     (or (and (eq L null)
              tt
         )
         (and (eq L (cons Hd Tl))
              (and (is_ab Hd) (is_ablist Tl))
         )
     ).

prog (neq X Y)
     (or (and (and (eq X a) (eq Y b))
              tt
         )
         (and (and (eq X b) (eq Y a))
              tt
         )
     ).

prog (count X L N)
     (or (and (and (eq L null) (eq N zero))
              tt
         )
     (or (and (and (eq L (cons X Xs)) (eq N (succ N')))
              (count X Xs N')
         )
         (and (eq L (cons Y Xs))
              (and (neq X Y) (count X Xs N))
         )
     )).

module cfg-aa.

prog (aa L)
     (or (and (eq L (cons a W))
              (ss W)
         )
         (and (eq L (cons b VW))
              (and (append V W VW) (and (aa V) (aa W)))
         )
     ).

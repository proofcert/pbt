module cfg-bb.

prog (bb L)
     (or (and (eq L (cons b W))
              (ss W)
         )
         (and (eq L (cons a VW))
              (and (append V W VW) (and (bb V) (bb W)))
         )
     ).

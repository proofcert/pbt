module cfg-aa.

prog (aa L)
     [(np "aa-cons-a" (and (eq L (cons a W))
                           (ss W))),
      (np "aa-cons-b" (and (eq L (cons b VW))
                           (and (append V W VW) (and (aa V) (aa W))))) ].

module cfg-bb.

prog (bb L)
     [(np "bb-cons-b" (and (eq L (cons b W))
                           (ss W))),
      (np "bb-cons-a" (and (eq L (cons a VW))
                           (and (append V W VW) (and (bb V) (bb W))))) ].

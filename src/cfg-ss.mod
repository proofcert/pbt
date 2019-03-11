module cfg-ss.

prog (ss L)
     [(np "ss-null"   (eq L null)),
      (np "ss-cons-b" (and (eq L (cons b W))
                           (aa W))),
      (np "ss-cons-a" (and (eq L (cons a W))
                           (bb W))) ].

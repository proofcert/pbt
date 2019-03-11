module cfg-ss-bug1.

prog (ss L)
     [(np "ss-null"   (eq L null)),
      (np "ss-cons-b" (and (eq L (cons b W))
                           (ss W))), % Bug 1
      (np "ss-cons-a" (and (eq L (cons a W))
                           (bb W))) ].

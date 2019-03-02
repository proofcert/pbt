module cfg-ss-bug1.

prog (ss L)
     (or (and (eq L null)
              tt
         )
     (or (and (eq L (cons b W))
              (ss W) % Bug 1
         )
         (and (eq L (cons a W))
              (bb W)
         )
     )).

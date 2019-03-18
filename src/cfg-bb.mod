module cfg-bb.

prog (bb (cons b W)) (ss W).
prog (bb (cons a VW)) (and (append V W VW) (and (bb V) (bb W))).

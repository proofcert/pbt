module cfg-ss-bug1.

prog (ss null) (tt).
prog (ss (cons b W)) (ss W). % Bug 1
prog (ss (cons a W)) (bb W).

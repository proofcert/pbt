module cfg-aa.

prog (aa (cons a W)) (ss W).
prog (aa (cons b VW)) (and (append V W VW) (and (aa V) (aa W))).

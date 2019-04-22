module cfg-aa.

prog (aa (cons a W)) (ss W).
prog (aa (cons b VW)) (and (append V W VW) (and (aa V) (aa W))).
prog (append null L L) tt.
prog (append (cons X L) K (cons X M)) (append L K M).
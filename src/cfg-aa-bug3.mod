module cfg-aa-bug3.

prog (aa (cons a W)) (ss W).
%prog (aa (cons b VW)) (and (append V W VW) (and (aa V) (aa W))). % Bug 3

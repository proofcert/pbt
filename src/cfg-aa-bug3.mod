module cfg-aa-bug3.

prog (aa L)
%     (or % Bug 3
         (and (eq L (cons a W))
              (ss W)
         )
%         (and (eq L (cons b VW))
%              (and (append V W VW) (and (aa V) (aa W)))
%         )
%     )
     .

module stlc-step-cbn.

% Below is a proposal for call-by-name evaluation using small step
% semantics.  One conjecture we could have is that for every program,
% its call-by-value and call-by-name are the same.  There is a small
% counterexample.

% we should move it to progs
prog (stepn (app (c hd) (app (app (c cns) X) XS)) X) (and (is_value X) (is_value XS)).
prog (stepn (app (c tl) (app (app (c cns) X) XS)) XS) (and (is_value X) (is_value XS)).
prog (stepn (app (lam M T) M') (M M')) tt.  % W = M M', dynamic pattern OK?
prog (stepn (app M1 M2) (app M1' M2)) (stepn M1 M1').
%prog (stepn (app V M2) (app V M2')) (and (is_value V) (stepn M2 M2')).

prog (cbn V V) (is_value V).
prog (cbn M V) (and (step M N) (cbn N V)).

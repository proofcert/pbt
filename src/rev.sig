sig rev.
accum_sig kernel.

kind   elt       type.
type   a, b, c   elt.

type   is_elt       elt -> prolog.
type   is_eltlist   lst elt -> prolog.

type   rev   lst A -> lst A -> prolog.

% Test
type   cexrev   lst elt -> lst elt -> o.

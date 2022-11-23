sig lst.
accum_sig nat.
accum_sig kernel.
% accum_sig fpc-qshrink.

kind   lst          type -> type.
type   null         lst A.
type   cons         A -> lst A -> lst A.

type   is_natlist   lst nat -> o.
type   ord          lst nat -> o.
type   ord_bad      lst nat -> o.
type   ins          nat -> lst nat -> lst nat -> o.
type   append       lst A -> lst A -> lst A -> o.
type   rev          lst A -> lst A -> o.

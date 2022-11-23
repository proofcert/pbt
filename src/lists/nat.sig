sig nat.
accum_sig kernel.
% accum_sig fpc-qshrink.

kind   nat      type.
type   zero     nat.
type   succ     nat -> nat.

type   is_nat   nat -> o.

type   leq      nat -> nat -> o.
type   gt       nat -> nat -> o.

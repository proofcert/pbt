sig test-lst.
accum_sig nat.
accum_sig lst.
accum_sig fpc-qbound.

type   check_ord_bad   nat -> lst nat -> cert -> o.
type   cex_ord_bad   nat -> lst nat -> o.
type   cex_ord_bad_shrink   nat -> lst nat -> nat -> lst nat -> o.
type   cex_ord_bad_debug    nat -> lst nat -> list string -> o.

type   cex_ord_bad2   nat -> nat -> lst nat -> o.

type nocex_rev   lst nat -> o.

type   cex_rev   cert -> lst nat -> o.


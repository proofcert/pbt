sig lists.
accum_sig infra.
% accum_sig random.

kind nat   type.
type z     nat.
type s     nat -> nat.
/* examples */
type nat                                     nat -> sl.
type nlist                              list nat -> sl.
type append, rev_acc      list A -> list A -> list A -> sl.
type revApp,reverse                    list A -> list A -> sl.
/* end */
type   leq      nat -> nat -> sl.
type   gt       nat -> nat -> sl.
type   ord          list nat -> sl.
type   ord_bad      list nat -> sl.
type   ins          nat -> list nat -> list nat -> sl.

type nocex_rev        cert -> list nat -> o.
type cex_rev          cert -> list nat -> o.

type cex_ord_bad      cert -> nat -> list nat -> o.
type cex_ord_test_r      (string -> o) -> nat -> list nat -> o.

type mk_list int -> list int -> o.


type cex_rev_test    (string -> o) -> list nat -> o.
type cex_rev_test_sym    (string -> o)  -> list nat -> o.


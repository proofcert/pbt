sig test-lst.
accum_sig fpcs.
accum_sig random.
accum_sig interp.
accum_sig kernel.

type nocex_rev        cert -> list nat -> o.
type cex_rev          cert -> list nat -> o.

type cex_ord_bad      cert -> nat -> list nat -> o.
type cex_ord_test_r      (string -> o) -> nat -> list nat -> o.

 type mk_list int -> list int -> o.


type cex_rev_test    (string -> o) -> list nat -> o.
type cex_rev_test_sym    (string -> o)  -> list nat -> o.


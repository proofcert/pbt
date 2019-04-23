sig lst.
accum_sig kernel.


type   is_natlist   lst nat -> prolog.
type   ord          lst nat -> prolog.
type   ord_bad      lst nat -> prolog.
type   ins          nat -> lst nat -> lst nat -> prolog.
type   append       lst A -> lst A -> lst A -> prolog.
type   rev           lst A -> lst A -> prolog.
type   leq      nat -> nat -> prolog.
type   gt       nat -> nat -> prolog.
type   is_nat   nat -> prolog.

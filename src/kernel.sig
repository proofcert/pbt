sig kernel.

% Helpers
type   memb     A -> list A -> o.
type   member   A -> list A -> o.

% Formulas and their terms
kind   prolog        type.
type   tt            prolog.
type   and, or       prolog -> prolog -> prolog.
type   some, nabla   (A -> prolog) -> prolog.
type   eq            A -> A -> prolog.

% Program and interpreter
kind   nprolog   type.
type   np        string -> prolog -> nprolog.

type   prog      prolog -> list nprolog -> o.
type   interp    prolog -> o.

% Certificates
kind   choice        type.
type   left, right   choice.

kind   idx   type.

kind   cert            type.
type   tt_expert       cert -> o.
type   or_expert       cert -> cert -> choice -> o.
type   and_expert      cert -> cert -> cert -> o.
type   unfold_expert   list nprolog -> cert -> cert -> string -> o.

% Checker
type   check   cert -> prolog -> o.

% A sample program
kind   nat      type.
type   zero     nat.
type   succ     nat -> nat.
type   is_nat   nat -> prolog.
type   leq      nat -> nat -> prolog.
type   gt       nat -> nat -> prolog.

kind   lst          type -> type.
type   null         lst A.
type   cons         A -> lst A -> lst A.
type   is_natlist   lst nat -> prolog.
type   ord          lst nat -> prolog.
type   ord_bad      lst nat -> prolog.
type   ins          nat -> lst nat -> lst nat -> prolog.
type   append       lst A -> lst A -> lst A -> prolog.

% A "quick"-style FP
kind   qbound    type.
type   qheight   int -> qbound.
type   qsize     int -> int -> qbound.
type   qgen      qbound -> cert.

% A randomized "quick"-style FPC
kind   qweight   type.
type   qw        string -> int -> qweight.

type   qtries    int -> list qweight -> cert.
type   qrandom   list qweight -> cert.

type   sum_weights     list nprolog -> list qweight -> int -> list qweight -> o.
type   select_clause   int -> list qweight -> string -> o.

% Certificate pairing
type   pair   cert -> cert -> cert.

% Tests
type   cex_ord_bad   nat -> lst nat -> o.

type   cex_ord_bad_random   nat -> lst nat -> o.

type   main   o.

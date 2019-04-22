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
type   prog      prolog -> prolog -> o.

kind   nprolog   type.
type   np        string -> prolog -> nprolog.
type   progs     prolog -> list nprolog -> o.

type   interp    prolog -> o.

% Term shrinkers
type   shrink    A -> A -> o.

% Certificates
kind   choice        type.
type   left, right   choice.

kind   idx   type.

kind   cert            type.
type   tt_expert       cert -> o.
type   or_expert       cert -> cert -> choice -> o.
type   and_expert      cert -> cert -> cert -> o.
type   some_expert     cert -> cert -> A -> o.
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

% An integer strict size (e.g., 4) becomes a range 4 .. 0, whose
% subtraction denotes exactly the size of a subterm to be generated.
type   qidsize    int -> qbound.
type   qidsize'   int -> int -> qbound.
type   qrgsize    int -> int -> qbound.

% Iterated and strict term heights.
type   qidheight    int -> qbound.
type   qidheight'   int -> int -> qbound.
type   qrgheight    int -> int -> qbound.

type   min   int -> int -> int -> o.

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

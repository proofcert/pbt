sig test.

% Formulas and their terms
kind   prolog, tm   type.
type   tt           prolog.
type   and, or      prolog -> prolog -> prolog. 
type   all          (tm -> prolog) -> prolog.

% Explicit variable encoding
kind   evs   type.
type   fst   evs -> tm.
type   rst   evs -> evs.

% Program and interpreter
type   interp   (evs -> prolog) -> o.
type   prog     prolog -> prolog -> o.

% Certificates
kind   choice        type.
type   left, right   choice.

kind   idx   type.

kind   cert          type.
type   tt_expert     cert -> o.
type   or_expert     cert -> cert -> choice -> o.
type   and_expert    cert -> cert -> cert -> o.
type   prog_expert   cert -> cert -> o.

% Checker
type   check   cert -> (evs -> prolog) -> o.

% A sample program
type   zero   tm.
type   succ   tm -> tm.

type   is_nat   tm -> prolog.

% A "quick"-style FP
kind   qbound    type.
type   qheight   int -> qbound.
type   qsize     int -> int -> qbound.
type   qgen      qbound -> cert.

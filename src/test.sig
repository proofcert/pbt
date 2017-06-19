sig test.

% Formulas and their terms
kind   prolog, tm   type.
type   tt            prolog.
type   and, or       prolog -> prolog -> prolog.
type   some, nabla   (tm -> prolog) -> prolog.

% Program and interpreter
type   interp   prolog -> o.
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
type   check   cert -> prolog -> o.

% A sample program
type   zero     tm.
type   succ     tm -> tm.
type   is_nat   tm -> prolog.

type   null         tm.
type   cons         tm -> tm -> tm.
type   is_natlist   tm -> prolog.

type   error    tm.
type   lam      (tm -> tm) -> tm.
type   is_exp   tm -> prolog.

% A "quick"-style FP
kind   qbound    type.
type   qheight   int -> qbound.
type   qsize     int -> int -> qbound.
type   qgen      qbound -> cert.

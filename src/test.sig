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

% A sample program
type   zero   tm.
type   succ   tm -> tm.

type   is_nat   tm -> prolog.

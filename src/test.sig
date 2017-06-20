sig test.

% Formulas and their terms
kind   prolog, tm    type.
type   tt            prolog.
type   and, or       prolog -> prolog -> prolog.
type   some, nabla   (A -> prolog) -> prolog.

% Program and interpreter
type   prog     prolog -> prolog -> o.
type   interp   prolog -> o.

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
% TODO: Better typing
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

% c hd nl tl
% cns (old cons)

type   c        tm -> tm.
type   app      tm -> tm -> tm.
type   lam      (tm -> tm) -> tm -> tm.
type   error    tm.

type cns,hd,tl,nl  tm.
type toInt         nat -> tm.

type intTy   tm.
type funTy   tm -> tm -> tm.
type listTy  tm.

type   bind         tm -> tm -> tm.
type   is_ty        tm -> prolog.
type   is_cnt       tm -> prolog.
type   is_exp       tm -> prolog.
type   is_elt       tm -> prolog.
type   is_eltlist   lst tm -> prolog.
type   tcc          tm -> tm -> prolog.
type   memb         tm -> lst tm -> prolog.
type   wt           lst tm -> tm -> tm -> prolog.
type   is_value     tm -> prolog.
type   is_error     tm -> prolog.
type   step         tm -> tm -> prolog.
type   progress     tm -> prolog.

% A "quick"-style FP
kind   qbound    type.
type   qheight   int -> qbound.
type   qsize     int -> int -> qbound.
type   qgen      qbound -> cert.

% Tests
type   cex_ord_bad   nat -> lst nat -> o.
type   cex_prog_1    tm -> tm -> o.

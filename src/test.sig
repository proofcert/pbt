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
type   zero     tm.
type   succ     tm -> tm.
type   is_nat   tm -> prolog.
type   leq      tm -> tm -> prolog.
type   gt       tm -> tm -> prolog.

type   null         tm.
type   cons         tm -> tm -> tm.
type   is_natlist   tm -> prolog.
type   ord          tm -> prolog.
type   ord_bad      tm -> prolog.
type   ins          tm -> tm -> tm -> prolog.

% c hd nl tl
% cns (old cons)

type   c        tm -> tm.
type   app      tm -> tm -> tm.
type   lam      (tm -> tm) -> tm -> tm.
type   error    tm.

type cns,hd,tl,nl  tm.
type toInt         tm -> tm.

type intTy   tm.
type funTy   tm -> tm -> tm.
type listTy  tm.

type   bind         tm -> tm -> tm.
type   is_ty        tm -> prolog.
type   is_cnt       tm -> prolog.
type   is_exp       tm -> prolog.
type   is_elt       tm -> prolog.
type   is_eltlist   tm -> prolog.
type   tcc          tm -> tm -> prolog.
type   memb         tm -> tm -> prolog.
type   wt           tm -> tm -> tm -> prolog.
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
type   cex_ord_bad   tm -> tm -> o.
type   cex_prog_1    tm -> tm -> o.

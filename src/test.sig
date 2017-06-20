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

kind   cnt, exp, ty, elt   type.

type   c        cnt -> exp.
type   app      exp -> exp -> exp.
type   lam      (exp -> exp) -> ty -> exp.
type   error    exp.

type   cns, hd, tl, nl   cnt.
type   toInt             nat -> cnt.

type   intTy    ty.
type   funTy    ty -> ty -> ty.
type   listTy   ty.

type   bind         exp -> ty -> elt.
type   is_ty        ty -> prolog.
type   is_cnt       cnt -> prolog.
type   is_exp       exp -> prolog.
type   is_elt       elt -> prolog.
type   is_eltlist   lst elt -> prolog.
type   tcc          cnt -> ty -> prolog.
type   memb         elt -> lst elt -> prolog.
type   wt           lst elt -> exp -> ty -> prolog.
type   is_value     exp -> prolog.
type   is_error     exp -> prolog.
type   step         exp -> exp -> prolog.
type   progress     exp -> prolog.

% A "quick"-style FP
kind   qbound    type.
type   qheight   int -> qbound.
type   qsize     int -> int -> qbound.
type   qgen      qbound -> cert.

% Tests
type   cex_ord_bad   nat -> lst nat -> o.
type   cex_prog_1    exp -> ty -> o.

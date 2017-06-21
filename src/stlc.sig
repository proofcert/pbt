sig stlc.
accum_sig kernel.

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

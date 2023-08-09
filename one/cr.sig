sig cr.
accum_sig infra.
/* lambdas */
kind   exp  type.
type   app      exp -> exp -> exp.
type   lam      (exp -> exp) -> exp.
/* end */
type beta       exp -> exp -> sl.
type is_exp            exp -> sl.

/* joinable */
type joinableS    (exp -> exp -> sl) -> exp -> exp -> sl.
type joinable_teta     exp -> exp -> ty -> sl.
type prop_dia    cert -> (exp -> exp -> sl) -> exp -> o.
/* end */
type prop_eta_dia    cert -> exp  -> ty -> o.

/* wt */
type  wt           exp -> ty -> sl.
type  teta         exp -> exp -> ty ->  sl.
/* end */
type wt_pres     exp -> exp -> ty -> sl.
type prop_eta_pres    cert -> exp -> exp -> ty -> o.

kind ty   type.
type unitTy ty.
type arTy, pairTy ty -> ty -> ty.
type  is_ty           ty -> sl.

type ep  exp.	 % empty pair ep : unit
type fst, snd   exp -> exp.
type pair exp -> exp -> exp.
type example   int -> exp -> o.
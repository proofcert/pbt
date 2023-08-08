sig sect6.

kind sl       type.           % Specification logic formulas
type tt       sl.             % True
type and, or  sl -> sl -> sl. % Conjunction and disjunction
type some     (A -> sl) -> sl.% Existential quantifier
type eq       A  -> A  -> sl. % Equality
infixr and    50.
infixr or     40.
infix  eq     60.

type   <>==   sl -> sl -> o.  % Predicate for storing sl clauses
infix  <>==   30.

type member  A -> list A -> o.

/* new */
type all     (A -> sl) -> sl.     % Universal quantifier
type =o      sl  -> sl -> sl.     % Intuitionistic implication
infixr =o    30.
type interp   list sl -> sl -> o. % The new type for interp
/* end */

/* sigs */
% Certificates
kind cert          type.
kind choice        type.
type left, right   choice.

% The types for the expert predicates
type ttE, eqE                   cert -> o.
type backchainE         cert -> cert -> o.
type someE         cert -> cert -> A -> o.
type andE       cert -> cert -> cert -> o.
type orE      cert -> cert -> choice -> o.
/* end */

/* check */
type check  cert -> list sl -> sl -> o. % New type for check
type initE  cert -> o.                  % Expert for initial rule
type impC   cert -> cert -> o.          % Clerk for implication
type allC   cert -> (A -> cert) -> o.   % Clerk for universal 
/* end */

/* lambdas */
kind   exp       type.
type   app       exp -> exp -> exp.
type   lam       (exp -> exp) -> exp.
/* end */
/* beta */
type   beta      exp -> exp -> sl.
type   is_exp           exp -> sl.
/* end */

/* joinable */
type joinable    (exp -> exp -> sl) -> exp -> exp -> sl.
type prop_dia    cert -> (exp -> exp -> sl) -> exp -> o.
/* end */
type joinable_teta     exp -> exp -> ty -> sl.
type  is_ty           ty -> sl.
/* wt */
type  wt           exp -> ty -> sl.
type  teta         exp -> exp -> ty ->  sl.
/* end */

type wt_pres     exp -> exp -> ty -> sl.
type prop_eta_pres    cert -> exp -> exp -> ty -> o.
type prop_eta_dia    cert -> exp  -> ty -> o.

kind ty   type.
type unitTy ty.
type arTy, pairTy ty -> ty -> ty.

type unit  exp.	 % empty pair unit : unitTy
type fst, snd   exp -> exp.
type pair exp -> exp -> exp.

% For the FPCs
type height  int -> cert.
type sze     int -> int -> cert.
kind max     type.
type max     max    -> cert.
type binary  max    -> max -> max.
type choose  choice -> max -> max.
type term    A      -> max -> max.
type empty   max.
type   <c>   cert ->  cert ->  cert.
infixr <c>   5.

% Additional constructor needed for the max certificate

type ab   (A -> max) -> max.

type example   int -> exp -> o.


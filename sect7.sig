sig sect7.

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

type all      (A -> sl) -> sl.     % Universal quantifier
type =o       sl  -> sl -> sl.     % Intuitionistic implication
infixr =o     35.

/* llinterp */
type bang         sl -> sl.
type -o           sl -> sl -> sl.     % Linear implication
infixr -o         35.
kind optsl        type.               % Option SL formulas
type del          optsl.
type bnd, ubnd    sl -> optsl.

type llinterp  list optsl -> list optsl -> sl -> o.
type pick      sl -> list optsl -> list optsl -> o.
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

/* new */
type llcheck  cert -> list optsl -> list optsl -> sl -> o. % New type for llcheck
type initE  cert -> o.                  % Expert for initial rule
type impC   cert -> cert -> o.          % Clerk for implication
type limpC  cert -> cert -> o.          % Clerk for linear implication
type allC   cert -> (A -> cert) -> o.   % Clerk for universal 
/* end */
type bangE  cert -> cert -> o.

/* toggle */
type on, off    sl.
type toggle     sl -> sl.
/* end */

/* perm */
type element   A -> sl.
type perm      list A -> list A -> sl.
/* end */

/* lambdas */
kind   exp  type.
type   app      exp -> exp -> exp.
type   lam      (exp -> exp) -> exp.
/* end */
type beta       exp -> exp -> sl.
type is_exp            exp -> sl.
/* is_lexp */
type is_lexp           exp -> sl.
/* end */

/* joinable */
type joinableS    (exp -> exp -> sl) -> exp -> exp -> sl.
type dia_cexS    cert -> (exp -> exp -> sl) -> exp -> o.
/* end */

/* wt */
type  wt           exp -> ty -> sl.
type  teta         exp -> exp -> ty ->  sl.
/* end */

type wt_pres     exp -> exp -> ty -> sl.
type prop_eta_pres    cert -> exp -> exp -> ty -> o.

kind ty   type.
type unitTy ty.
type arTy, pairTy ty -> ty -> ty.

type ep  exp.	 % empty pair ep : unit
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

type ab        (A -> max) -> max.
type example   int -> exp -> o.

% Signature specifically for Section 7.2

% lambda calculus with a single counter/register that can be set or read
% easy to generalize to n registers or to  SML-llke locations

%% e ::= x | M N | lam M | get | set N | u

%% define seq as usual seq M N == (\_ . N) M

type seq          exp -> exp -> exp.
/* newcons */
type cst    int -> exp. % Coerce integers into expressions
type set    int -> exp. % Command to set the counter
type get    exp.        % Command to get the counter's value
type unit   exp.        % Value returned by set
/* end */

/* cbnv */
type is_prog, value   exp -> sl.
type is_int, counter  int -> sl.
type cbn, cbv         exp -> exp ->  sl -> sl.
/* end */

/* eval */
type eval   (exp -> exp ->  sl -> sl) -> exp -> exp -> o.
/* end */

%type tl               sl.

type top_level (sl -> sl) -> list optsl -> list optsl -> list optsl -> list optsl -> o.

type prog        int -> exp -> o.
type prop_cbnv    cert -> exp -> exp -> exp -> o.

/* pres */
type prop_pres1, prop_pres2
     cert -> (exp -> exp -> sl -> sl) -> exp -> exp -> o.
/* end */


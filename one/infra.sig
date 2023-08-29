sig infra.
accum_sig random.

kind sl       type.           % Specification logic formulas
type tt,ff    sl.             % True
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

type llinterp     list optsl -> list optsl -> sl -> o.
type pick         sl -> list optsl -> list optsl -> o.
/* end */

/* sigs */
% Certificates
kind cert          type.
kind choice        type.
type left, right   choice.

/* random */
type   random   cert.
/* end */
% type   rtries    int -> cert.
% type   rtriesW   string -> int -> cert.

type   iterate   int -> o.
% The types for the expert predicates
type ttE, eqE                     cert -> o.
type backchainE     sl -> cert -> cert -> o.
type someE           cert -> cert -> A -> o.
type andE         cert -> cert -> cert -> o.
type orE        cert -> cert -> choice -> o.
/* end */

/* new */
type llcheck  cert -> list optsl -> list optsl -> sl -> o. % New type for llcheck
type initE  cert -> o.                  % Expert for initial rule
type impC   cert -> cert -> o.          % Clerk for implication
type limpC  cert -> cert -> o.          % Clerk for linear implication
type allC   cert -> (A -> cert) -> o.   % Clerk for universal 
/* end */
type bangE  cert -> cert -> o.

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

/* weight_cert */
type noweight      cert.
type cases         int -> list int -> int -> cert.
/* end */

/* weight_pred */
type weights       sl -> list int -> o.
/* end */

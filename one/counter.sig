sig counter.
accum_sig infra.
accum_sig cr.

/* toggle */
type on, off    sl.
type toggle     sl -> sl.
/* end */

/* perm */
type element   A -> sl.
type perm      list A -> list A -> sl.
/* end */

/* is_lexp */
type is_lexp           exp -> sl.
/* end */

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

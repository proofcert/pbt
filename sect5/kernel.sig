sig kernel.
accum_sig interp.


/*
% Object-level formulas
kind oo        type.
type tt        oo.
type and, or   oo  -> oo -> oo.
type some      (A -> oo) -> oo.
type eq        A -> A  -> oo.

% Object-level Prolog clauses are
% stored as facts (prog A Body).
type prog      oo -> oo -> o.
*/
/* sigs */
% Certificates
kind cert          type.
kind choice        type.
type left, right   choice.

% The types for the expert predicates
type ttE, eqE                   cert -> o.
type backchainE         sl -> cert -> cert -> o.
type someE         cert -> cert -> A -> o.
type andE       cert -> cert -> cert -> o.
type orE      cert -> cert -> choice -> o.
/* end */

/*
/* checkx */
% type backchainEx  sl -> cert -> cert -> o.
/* end */
*/
type check    cert -> sl -> o.
% A sample program
kind   nat      type.
type   zero     nat.
type   succ     nat -> nat.
type   is_nat   nat -> sl.
type   leq      nat -> nat -> sl.
type   gt       nat -> nat -> sl.
type   is_natlist   lst nat -> sl.
kind   lst          type -> type.
type   null         lst A.
type   cons         A -> lst A -> lst A.

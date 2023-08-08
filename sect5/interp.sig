sig interp.
/* interp */
kind sl       type.           % Specification logic formulas
type tt,ff       sl.             % True, False
type and, or  sl -> sl -> sl. % Conjunction and disjunction
type some     (A -> sl) -> sl. % Existential quantifier
type eq       A  -> A  -> sl. % Equality

infixr and    50.
infixr or     40.
infix  eq     60.

type   <>==   sl -> sl -> o.  % Predicate for storing sl clauses
infix  <>==   30.
type interp   sl -> o.        % Interpreter of sl goals
/* end */
/* nabla */
type nabla,all     (A -> sl) -> sl.
/* end */
type progs    sl -> list sl -> o.  % list based

kind nat   type.
type z     nat.
type s     nat -> nat.
/* examples */
type nat                                     nat -> sl.
type nlist                              list nat -> sl.
type append, rev_acc      list A -> list A -> list A -> sl.
type revApp,reverse                    list A -> list A -> sl.
/* end */
type   leq      nat -> nat -> sl.
type   gt       nat -> nat -> sl.
type   ord          list nat -> sl.
type   ord_bad      list nat -> sl.
type   ins          nat -> list nat -> list nat -> sl.
type  member  A -> list A -> o.
type nlistp                          list nat -> sl. %with prog

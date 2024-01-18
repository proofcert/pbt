/* 
 * Interface for code for transforming formulas into prenex normal form
 */

sig  f.
/* The basic categories in our encoding of first-order logic; the sort
term is the type of terms and form is the type of formulas */


kind   term   type.
kind   form   type.

/* The constants and function symbols */
type   a      term.
type   b      term.
type   c      term.
type   f      term -> term.

/* The predicate symbols */
type   path   term -> term -> form.
type   adj    term -> term -> form.


/*
 * This file defines encodings for the logical symbols in a 
 * first-order logic. 
 */


/* Constants encoding the logical symbols; note the types of the 
generalized quantifiers */
type   perp    form.
type   tru     form.
type   conj     form -> form -> form.
type   disj      form -> form -> form.
type   imp     form -> form -> form.
type   allq     (term -> form) -> form.
type   sme    (term -> form) -> form.


/* Some operator declarations for syntactic convenience */
infixr  conj   120.
infixr  disj    120.
infixr  imp   110.

/* this predicate definition is used but not changed */
type  quant_free   form -> o.

/* this definition changes in this module */
type  termp        term -> o.


type  prenex     form -> form -> o.
type  is_prenex     form -> o.


/*
 * Predicates for transforming formulas into prenex normal form 
 * assuming classical logic equivalences. This is an example of 
 * analyzing formula structure, including recursion over bindings
 * and generating modified structure based on this analysis
 */

module  f.

type  merge  (form -> form -> o).
type  atom         form -> o.

/* recognizer for terms */
termp a.
termp b.
termp c.
termp (f X) :- termp X.

/* recognizer for atomic formulas */
atom (path X Y) :- termp X, termp Y.
atom (adj X Y) :- termp X, termp Y.

/* recognizer for quantifier free formulas */
quant_free perp.
quant_free tru.
quant_free A :- atom A.
quant_free (B conj C) :- quant_free B, quant_free C.
quant_free (B disj C) :- quant_free B, quant_free C.
quant_free (B imp C) :- quant_free B, quant_free C.


(prenex B B) :- (quant_free B), !. 
(prenex (B conj C) D) :- (prenex B U), (prenex C V), (merge (U conj V) D).
(prenex (B disj C) D) :- (prenex B U), (prenex C V), (merge (U disj V) D).
(prenex (B imp C) D) :- (prenex B U), (prenex C V), (merge (U imp V) D).
(prenex (allq B) (allq D)) :- (pi X\ ((termp X) => (prenex (B X) (D X)))).

(prenex (sme B) (sme D)) :- (pi X\ ((termp X) => (prenex (B X) (D X)))).



(is_prenex (allq B)) :- (pi X\ ((termp X) => (is_prenex (B X)))).
(is_prenex (sme B)) :- (pi X\ ((termp X) => (is_prenex (B X)))).
(is_prenex B) :- (quant_free B). 

/* This predicate is for moving out quantifiers appearing at the head of the 
immediate subformulas of a formula with a propositional connective as its 
top-level symbol */
(merge ((allq B) conj (allq C)) (allq D)) :-
       (pi X\ ((termp X) => (merge ((B X) conj (C X)) (D X)))).
(merge ((allq B) conj C) (allq D)) :- 
       (pi X\ ((termp X) => (merge ((B X) conj C) (D X)))).
(merge (B conj (allq C)) (allq D)) :- 
       (pi X\ ((termp X) => (merge (B conj (C X)) (D X)))).

(merge ((sme B) conj C) (sme D)) :- 
       (pi X\ ((termp X) => (merge ((B X) conj C) (D X)))).
(merge (B conj (sme C)) (sme D)) :-
       (pi X\ ((termp X) => (merge (B conj (C X)) (D X)))).

(merge ((allq B) disj C) (allq D)) :-
       (pi X\ ((termp X) => (merge ((B X) disj C) (D X)))).
(merge (B disj (allq C)) (allq D)) :-
       (pi X\ ((termp X) => (merge (B disj (C X)) (D X)))).
(merge ((sme B) disj (sme C)) (sme D)) :-
       (pi X\ ((termp X) => (merge ((B X) disj (C X)) (D X)))).
(merge ((sme B) disj C) (sme D)):-
       (pi X\ ((termp X) => (merge ((B X) disj C) (D X)))).
(merge (B disj (sme C)) (sme D)) :-
       (pi X\ ((termp X) => (merge (B disj (C X)) (D X)))).

(merge ((allq B) imp (sme C)) (sme D)) :- 
       (pi X\ ((termp X) => (merge ((B X) imp (C X)) (D X)))).
(merge ((allq B) imp C) (sme D)) :- 
       (pi X\ ((termp X) => (merge ((B X) imp C) (D X)))).
(merge ((sme B) imp C) (allq D)) :-
       (pi X\ ((termp X) => (merge ((B X) imp C) (D X)))).
(merge (B imp (allq C)) (allq D)) :-
       (pi X\ ((termp X) => (merge (B imp (C X)) (D X)))).
(merge (B imp (sme C)) (sme D)) :-
       (pi X\ ((termp X) => (merge (B imp (C X)) (D X)))).

(merge B B) :- (quant_free B).



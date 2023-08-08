module fpcs.

%backchainEx A B C :- announce (backchainEx A B C).
%weights A B       :- announce (weights A B).

/* iterate */
iterate N :- N > 0.
iterate N :- N > 0, N' is N - 1, iterate N'.
/* end */

/* resources */
ttE     (height _).
eqE     (height _).
orE     (height H) (height H) _.
someE   (height H) (height H) _.
andE    (height H) (height H) (height H).
backchainE _ (height H) (height H') :- H  > 0, H' is H  - 1.

ttE     (sze In In).
eqE     (sze In In).
orE     (sze In Out) (sze In Out) _.
someE   (sze In Out) (sze In Out) _.
andE    (sze In Out) (sze In Mid) (sze Mid Out).
backchainE _  (sze In Out) (sze In' Out) :-
         In > 0, In' is In - 1.
/* end */
%backchainE (qtriesW Id N) Cont :- N > 0, N' is N - 1, backchainE (qtriesW Id N') Cont.
/* random */
ttE random.
eqE random.
orE random random Choice :- next_bit I,
  ((I = 0, Choice = left); (I = 1, Choice = right)).
someE random random _.
andE  random random random.
backchainE _ random random.
/* end */

% DM Another approach to putting weights on disjunctive cases.
% Assume that when we use case-weight, our clauses are of the form
%      head <>== b1 or (b2 or ... or (bn or tt)).
% Here, the disjunction only appears at the top-level (no bi formula
% contains disjunction) and that the disjunctions are associated to
% the right (which is the default declaration).  Note that the
% disjunction must end with tt.

% Weights for the disjunctions should always add up to 128.  There
% must be a top-level disjunction in the body (otherwise, don't use
% weights).

% Since backchainE needs to know the predicate on which it is being
% invoked, it seems that we need another backchain expert that can
% examine the atom it is openning.

/* weighty */
ttE     noweight.
eqE     noweight.
andE    noweight noweight noweight.
someE   noweight noweight _.

backchainE Atom noweight (cases Rnd Ws 0) :-
   weights Atom Ws, read_7_bits Rnd.

orE (cases Rnd (W::Ws) Acc) Cert Choice :- Acc' is Acc + W,
  ((Acc'  > Rnd, Choice = left,  Cert = noweight) ;
   (Acc' =< Rnd, Choice = right, Cert = (cases Rnd Ws Acc'))).

weights (nat _)    [32,96].
weights (nlist _)  [32,96].
/* end */

weights (ord_bad _)   [20, 40, 68].
weights (reverse _ _) [20,108].

% DM end of example with weights

% Quick trick: iterate at the starting point of the evaluation
% backchainE (rtries N) random :- iterate N.
% backchainE (rtriesW Id N) (qw Cont) :- qdistr Id Cont, iterate N.
%backchainE (qtriesW Id N) (qw Cont) :- qdistr Id Cont, N > 0.

/* max */
ttE     (max empty).
eqE     (max empty).
orE     (max (choose C M)) (max M) C.
someE   (max (term   T M)) (max M) T.
andE    (max (binary M N)) (max M) (max N).
backchainE _ (max M) (max M).
/* end */
/* pairing */
ttE     (A <c> B) :- ttE A, ttE B.
eqE     (A <c> B) :- eqE A, eqE B.
someE   (A <c> B) (C <c> D) T         :- someE A C T, someE B D T.
orE     (A <c> B) (C <c> D) E         :- orE A C E, orE B D E. 
andE    (A <c> B) (C <c> D) (E <c> F) :- andE A C E, andE B D F. 
backchainE At (A <c> B) (C <c> D)  :-
        backchainE At A C, backchainE At B D.
/* end */

ttE   (l-or-r In In).
eqE   (l-or-r In In).
orE   (l-or-r [C|In] Out)
      (l-or-r In Out) C.
someE (l-or-r In Out) (l-or-r In Out) _.
andE  (l-or-r In Out) (l-or-r In Mid)
                      (l-or-r Mid Out).
backchainE _ (l-or-r In Out) (l-or-r In Out).

/* collect */
ttE   (collect In In).
eqE   (collect In In).
orE   (collect In Out)
      (collect In Out) C.
andE  (collect In Out) (collect In Mid) (collect Mid Out).
backchainE _ (collect In Out) (collect In Out).
someE (collect [(c_nat T) | In] Out)
      (collect In Out) (T : nat).
someE (collect [(c_list_nat T)|In] Out)
      (collect In Out) (T : list nat).

subterm Item Item.
subterm Item (c_nat (succ M)) :- subterm Item (c_nat M).
subterm Item (c_list_nat (Nat::L)) :- subterm Item (c_nat Nat) ;
                                      subterm Item (c_list_nat L).
/* end */
/* huniv */
ttE     (huniv _).
eqE     (huniv _).
orE     (huniv Pred) (huniv Pred) _.
andE    (huniv Pred) (huniv Pred) (huniv Pred).
backchainE _ (huniv Pred) (huniv Pred).
someE (huniv Pred) (huniv Pred) (T:nat) :-
  Pred (c_nat T).
someE (huniv Pred) (huniv Pred) (T:list nat) :-
  Pred (c_list_nat T).
/* end */

/*
/* weights */
ttE     (qw qid).
eqE     (qw qid).
andE    (qw (qand Left Right)) (qw Left) (qw Right).
orE     (qw (qor WL WR L R)) (qw Cont) Side :-
  qchoose WL WR Side,
  ((Side = left, Cont = L);
   (Side = right, Cont = R)).
someE   (qw Cont) (qw Cont) _.
backchainE (qw (qprog Id)) (qw Cont) :- qdistr Id Cont.
/* end */
qchoose WL WR Choice :-
  Rng is WL + WR, term_to_string Rng RngStr,
  Cmd is "shuf -i 1-" ^ RngStr ^ " -n 1 -o rand.txt",
  system Cmd _, system "sed -i 's/$/\\./' rand.txt" _,
  open_in "rand.txt" In, readterm In Rnd, close_in In,
  ((Rnd <= WL, Choice = left); (Rnd > WL, Choice = right)).
%  next_bit I0, next_bit I1, next_bit I2, next_bit I3,
%  next_bit I4, next_bit I5, next_bit I6, next_bit I7,
%  R is I0 + I1 * 2 + I2 * 4 + I3 * 8 + I4 * 16 + I5 * 32 + I6 * 64 + I7 * 128,
%  T is (WL * 256) div (WL + WR),
%  ((R <= T, Choice = left); (R > T, Choice = right)).

*/

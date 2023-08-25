module infra.
accumulate random.
/* llinterp */
llinterp In In  tt.
llinterp In In  (T eq T).
llinterp In Out (G1 and G2) :-
	 llinterp In Mid G1,
         llinterp Mid Out G2.
llinterp In Out (G1 or G2)  :-
	  llinterp In Out G1;
          llinterp In Out G2.
llinterp In Out (some G) :-
	 llinterp In Out (G T).
llinterp In Out (all G)  :-
	 pi x\ llinterp In Out (G x).
llinterp In In  (bang G) :-
	 llinterp In In G.
llinterp In Out (A =o G) :-
	 llinterp ((ubnd A)::In) ((ubnd A)::Out) G.
llinterp In Out (A -o G) :-
	 llinterp ((bnd A)::In) (del::Out) G.
llinterp In Out A        :-
	 pick A In Out; 
         (A <>== G), llinterp In Out G.

pick A (bnd A::L)  (del::L).
pick A (ubnd A::L) (ubnd A::L).
pick A (I::L)      (I::K) :- pick A L K.
/* end */

/* llcheck */
llcheck Cert In In  tt          :- ttE Cert.
llcheck Cert In In  (T eq T)    :- eqE Cert.
llcheck Cert In Out (G1 and G2) :- andE Cert Cert1 Cert2, 
                                 llcheck Cert1 In Mid G1, llcheck Cert2 Mid Out G2.
llcheck Cert In Out (G1 or G2)  :- orE Cert Cert' LR, 
                                ((LR = left,  llcheck Cert' In Out G1);
                                 (LR = right, llcheck Cert' In Out G2)).
llcheck Cert In Out (some G)    :- someE Cert Cert1 T, llcheck Cert In Out (G T).
llcheck Cert In Out (all G)     :- allC Cert Cert', 
                                 pi x\ llcheck (Cert' x) In Out (G x).
llcheck Cert In In  (bang G)    :- bangE Cert Cert', llcheck Cert' In In G.
llcheck Cert In Out (A =o G)    :- impC Cert Cert',
                                 llcheck Cert' ((ubnd A)::In) ((ubnd A)::Out) G.
llcheck Cert In Out (A -o G)    :- limpC Cert Cert',
                                 llcheck Cert ((bnd A)::In) (del::Out) G.
llcheck Cert In Out A           :- initE Cert, pick A In Out.
llcheck Cert In Out A           :- backchainE A Cert Cert', 
                                (A <>== G), llcheck Cert' In Out G.
/* end */


% Some fpcs
ttE     (height _).
eqE     (height _).
orE     (height H) (height H) _.
someE   (height H) (height H) _.
andE    (height H) (height H) (height H).
backchainE _ (height H) (height H') :- H  > 0, H' is H  - 1.
initE (height In) :- In > 0.
allC  (height In) (x\ height In).
impC  (height In) (height In).
limpC  (height In) (height In).

ttE     (sze In In).
eqE     (sze In In).
orE     (sze In Out) (sze In Out) _.
someE   (sze In Out) (sze In Out) _.
andE    (sze In Out) (sze In Mid) (sze Mid Out).
backchainE _ (sze In Out) (sze In' Out) :- In > 0, In' is In - 1.
initE (sze In In') :- In > 0, In' is In - 1.
allC  (sze In Out) (x\ sze In Out).
impC  (sze In Out) (sze In Out).
limpC  (sze In Out) (sze In Out).

ttE     (max empty).
eqE     (max empty).
orE     (max (choose C M)) (max M) C.
someE   (max (term   T M)) (max M) T.
andE    (max (binary M N)) (max M) (max N).
backchainE _ (max M) (max M).
initE (max empty).
allC  (max (ab C)) (x\ max (C x)).
impC  (max C) (max C).
limpC  (max C) (max C).

ttE     (A <c> B) :- ttE A, ttE B.
eqE     (A <c> B) :- eqE A, eqE B.
someE   (A <c> B) (C <c> D) T         :- someE A C T, someE B D T.
orE     (A <c> B) (C <c> D) E         :- orE A C E, orE B D E. 
andE    (A <c> B) (C <c> D) (E <c> F) :- andE A C E, andE B D F. 
backchainE P (A <c> B) (C <c> D)           :- backchainE P A C, backchainE P B D.
initE (A <c> B) :- initE A, initE B.
allC  (A <c> B) (x\ (C x) <c> (D x)) :- allC A C, allC B D.
impC  (A <c> B) (C <c> D) :- impC A C, impC B D.
limpC  (A <c> B) (C <c> D) :- impC A C, impC B D.


/* iterate */
iterate N :- N > 0.
iterate N :- N > 0, N' is N - 1, iterate N'.
/* end */

ttE random.
eqE random.
orE random random Choice :- next_bit I,
  ((I = 0, Choice = left); (I = 1, Choice = right)).
someE random random _.
andE  random random random.
backchainE _ random random.
initE (random).
allC  (random) (x\ random).
impC  random random.
limpC   random random.

% add other clauses

/* weighty */
ttE     noweight.
eqE     noweight.
andE    noweight noweight noweight.
someE   noweight noweight _.
initE (noweight).
allC  (noweight) (x\ noweight).
impC  noweight noweight.
limpC   noweight noweight.

backchainE Atom noweight (cases Rnd Ws 0) :-
   weights Atom Ws, read_7_bits Rnd.

orE (cases Rnd (W::Ws) Acc) Cert Choice :- Acc' is Acc + W,
  ((Acc'  > Rnd, Choice = left,  Cert = noweight) ;
   (Acc' =< Rnd, Choice = right, Cert = (cases Rnd Ws Acc'))).


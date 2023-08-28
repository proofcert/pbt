module lists.
% accumulate random.

(nat N)   <>== (N eq z) or
               (some N'\ N  eq (s N') and (nat N')) or ff.
(nlist L) <>== (L eq nil) or 
               (some N\ some Ns\ L eq (N::Ns) and (nat N) 
                                    and (nlist Ns)) or ff.
(append Xs Ys Zs) <>== ((Xs eq nil) and (Ys eq Zs)) or
                        (some X'\ some Xs'\ some Zs'\ Xs eq (X':: Xs') and (append Xs' Ys Zs') and (Zs eq (X' :: Zs'))).
(revApp L R) <>==
   ((L eq nil) and (R eq nil)) or
    some X\ some Xs\ some Ts\ (L eq (X::Xs)) and ((reverse Xs Ts) and (append Ts (X:: nil) R)).

(reverse L K) <>== (rev_acc L K nil).
(rev_acc L K A) <>== ((L eq nil) and (K eq A)) or 
                   some L'\ ( L eq (X::L')) and (rev_acc L' K (X::A)).

(leq N M) <>==
      ( N eq z) or
       some X\ (some Y\ (N eq  (s X)) and  (M eq  (s Y)) and (leq X Y)).

(gt N M) <>==
      (M eq z) and some K\ (N eq (s K)) or
       some X\ some Y\ ((N eq (s X)) and (( M eq (s Y)) and (gt X Y))).

(ord_bad L)  <>==
      (L eq nil) or
      some X\ ((L eq (X :: nil)) and (nat X)) or
      some Y\ some Rs\ ((L eq (X :: ( Y :: Rs))) and (leq X Y) and (ord_bad Rs))  or ff.

(ins X L R) <>==
       ( (L eq nil) and ( (R eq ( X :: nil)) and (nat X))) or
       some Y\ some Ys\ ((L eq ( Y :: Ys)) and (R eq  (X :: ( Y :: Ys)) and (leq X Y))) or
       some Y\ some Ys\  some Rs\ (L eq ( Y ::  Ys)) and
       	    (R eq (X :: Rs)) and (gt X Y)  and (ins X Ys Rs).

weights (nat _)    [32,96].
weights (nlist _)  [32,96].
/* end */

weights (ord_bad _)   [20, 40, 68].
weights (reverse _ _) [20,108].

% hello world: rv is involutive
% The following goal will fail since there is no counterexample.
% ?- nocex_rev (height 3) L.

nocex_rev  Gen L :-
	   llcheck Gen nil nil (nlist L), 
           llinterp nil nil (reverse L R),
	   not (llinterp nil nil (reverse R L)).

% our beloved example: reverse is not the id function
% The following will produce a number of counterexamples.
% ?- cex_rev (height 4) L.
%
% The answer substitution:
% L = z :: s z :: nil
%
% More solutions (y/n)? y
%
% The answer substitution:
% L = s z :: z :: nil
% More solutions (y/n)?

cex_rev Gen L :-
	llcheck Gen nil nil (nlist L),
	llinterp nil nil (reverse L R),
	not (L = R).

% ?- cex_rev_test oracle6  L.
%
% The answer substitution:
% L = z :: s (s (s (s (s (s z))))) :: s (s (s (s (s (s (s (s (s (s z))))))))) :: z :: z :: nil
%
% More solutions (y/n)? y
%
% The answer substitution:
% L = z :: s z :: s (s (s (s z))) :: s (s (s (s (s (s (s (s (s z)))))))) :: z :: z :: nil
%
% More solutions (y/n)? 

cex_rev_test O L :-
  open_oracle O (iterate 10, cex_rev noweight L).

% The following query fails.
%  ?- cex_rev_test_sym oracle8 L.
cex_rev_test_sym  O L :-
  open_oracle O ((iterate 10), nocex_rev noweight L).

% Insertion into a bad-ordered list might not be bad-ordered.
% [harness] ?- cex_ord_bad (height 4) N L.
%
% The answer substitution:
% L = z :: s z :: z :: nil
% N = z
%
% More solutions (y/n)? y
%
% The answer substitution:
% L = s z :: s z :: z :: nil
% N = z
%
% More solutions (y/n)?

cex_ord_bad Gen N L :-
	llcheck Gen nil nil  ((nat N) and (nlist L)),
	llinterp nil nil (ord_bad L),
% 	check Gen (ord_bad L),
	llinterp nil nil (ins N L O),
	not (llinterp nil nil (ord_bad O)).

% The following query tries upto 10 times to find a counterexample
% using randomized testing (thus getting different counterexamples).
%
% [harness] ?- cex_ord_test_r oracle8 N L.
%
% The answer substitution:
% L = s (s (s (s (s (s (s (s (s z)))))))) :: 
%     s (s (s (s (s (s (s (s (s z)))))))) :: z :: s z :: z :: s z :: 
%     s (s (s (s (s (s (s (s z))))))) :: nil
% N = s (s z)
%
% More solutions (y/n)? 

cex_ord_test_r  O N L :-
  open_oracle O ((iterate 10), cex_ord_bad noweight N L).



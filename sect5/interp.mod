module interp.

/* interp */
interp tt.
interp (T eq T).
interp (G1 and G2) :- interp G1, interp G2.
interp (G1 or G2)  :- interp G1 ; interp G2.
interp (some G)    :- interp (G T).
interp A           :- (A <>== G), interp G.
/* end */
/* nabla */
interp (nabla G)     :- pi x\ interp (G x).
interp (all G)     :- pi x\ interp (G x).
/* end */
% interp A                  :- progs A Gs, member G GS, interp G.

% (nat z)     <>== tt.
% (nat (s X)) <>== (nat X).
% (nlist nil)     <>== tt.
% (nlist (N::Ns)) <>== ((nat N) and (nlist Ns)).
% (append nil K K)         <>== tt.
% (append (X::L) K (X::M)) <>== (append L K M).
% (reverse L K)    <>== (rev L K nil).
% (rev nil A A)    <>== tt.
% (rev (X::L) K A) <>== (rev L K (X::A)).
/* examples */
(nat N)   <>== (N eq z) or
               (some N'\ N  eq (s N') and (nat N')) or ff.
(nlist L) <>== (L eq nil) or 
               (some N\ some Ns\ L eq (N::Ns) and (nat N) 
                                    and (nlist Ns)) or ff.
/* end */

% There was a mistake in append (which I think was not intended (X for X').  I fixed it.
% AM: not adding or ff unless it is used within a check in test-lst
(append Xs Ys Zs) <>== ((Xs eq nil) and (Ys eq Zs)) or
                        (some X'\ some Xs'\ some Zs'\ Xs eq (X':: Xs') and (append Xs' Ys Zs') and (Zs eq (X' :: Zs'))).
(revApp L R) <>==
   ((L eq nil) and (R eq nil)) or
    some X\ some Xs\ some Ts\ (L eq (X::Xs)) and ((reverse Xs Ts) and (append Ts (X:: nil) R)).

(reverse L K) <>== (rev_acc L K nil).
(rev_acc L K A) <>== ((L eq nil) and (K eq A)) or 
                   some L'\ ( L eq (X::L')) and (rev_acc L' K (X::A)).

member A (A:: _).
member A (_ :: Rs) :- member A Rs.

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


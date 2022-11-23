module lst.
%accumulate kernel.

%%%%%%%%%%%%%
% Shrinkers %
%%%%%%%%%%%%%

shrink (cons Hd Tl) Tl.
shrink (cons Hd Tl) Tl' :- shrink Tl Tl'.
shrink (cons Hd Tl) (cons Hd' Tl) :- shrink Hd Hd'.
shrink (cons Hd Tl) (cons Hd Tl') :- shrink Tl Tl'.
shrink (cons Hd Tl) (cons Hd' Tl') :- shrink Hd Hd', shrink Tl Tl'.

%%%%%%%%%%%%%%
% Generators %
%%%%%%%%%%%%%%


is_natlist null <>= true.
is_natlist (cons Hd Tl) <>= is_nat Hd, is_natlist Tl.


%%%%%%%%%%%%%%
% Predicates %
%%%%%%%%%%%%%%


 % (leq zero _) true.
 % (leq (succ X) (succ Y)) (leq X Y).

 % (gt (succ _) zero) true.
 % (gt (succ X) (succ Y)) (gt X Y).


 (ord null) <>= true.
 (ord (cons X null)) <>= (is_nat X).
 (ord (cons X (cons X Rs))) <>=  (ord (cons Y Rs)).

 (ord_bad null) <>= true.
 (ord_bad (cons X null)) <>= (is_nat X).
 (ord_bad (cons X (cons Z Rs))) <>=   (ord_bad Rs).

 (ins X null (cons X null)) <>= (is_nat X).
 (ins X (cons Y Ys) (cons X (cons Y Ys))) <>= (leq X Y).
 (ins X (cons Y Ys) (cons Y Rs)) <>= ((gt X Y) , (ins X Ys Rs)).

 (append null L L) <>= true.
 (append (cons X L) K (cons X M)) <>= (append L K M).


(rev null null) <>= true.
(rev (cons X Xs) R) <>= (rev Xs Ts, append Ts (cons X null) R).

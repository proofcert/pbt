module nat.

%%%%%%%%%%%%%
% Shrinkers %
%%%%%%%%%%%%%

shrink (succ N) N.
shrink (succ N) N' :- shrink N N'.

%%%%%%%%%%%%%%
% Generators %
%%%%%%%%%%%%%%

(is_nat zero) <>= true.
is_nat (succ N) <>= is_nat N.

%%%%%%%%%%%%%%
% Predicates %
%%%%%%%%%%%%%%
 (leq zero _) <>= true.
 (leq (succ X) (succ Y)) <>= (leq X Y).

 (gt (succ _) zero) <>= true.
 (gt (succ X) (succ Y)) <>= (gt X Y).

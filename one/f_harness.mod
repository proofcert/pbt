module f_harness.

% A good discipline is to put all accumulate-keywords in this harness
% file.  This will make sure that we do not have repeated code loaded.

accumulate infra.
accumulate f.

(is_form perp) <>== tt.
(is_form tru) <>== tt.
% is_form A <>== atom A.
( is_form (B conj C))  <>== (is_form B) and (is_form C).
( is_form (B disj C))  <>== is_form B and is_form C.
( is_form (B imp C)) <>== is_form B and is_form C.
(is_form (allq F)) <>== all w\ (is_form (F w)).
(is_form (sme F)) <>== all w\ (is_form (F w)).

prop_prenex Cert F PF :-
  	    llcheck Cert nil nil (is_form F),
	    prenex F PF,
	    not (is_prenex PF).
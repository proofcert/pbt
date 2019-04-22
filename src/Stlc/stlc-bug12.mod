module stlc-bug12.
% accumulate kernel.
% accumulate stlc.
accumulate driver2.
accumulate stlc-tcc.
accumulate stlc-wt-bug1.
accumulate stlc-value.
accumulate stlc-step.

% Tests
% cexprog E T :-
% 	check (pair (qgen (qheight 4)) (qgen (qsize 8 _))) (wt null E T),
% 	%check (qgen (qheight 1)) (is_ty T),
% %	interp (wt null E T),
% 	not (interp (progress E)),
% 	!.
% % cexprogb E 3 5.
% cexprogb E H S :-
% 	check (pair (qgen (qheight H)) (qgen (qsize S _))) (wt null E T),
% 	not (interp (progress E)),
% 	!.
% drive E :-
%       default H S,
%       drive_progb E H S.

% % default values to increase upon
% default 3 5.

% drive_progb E H S :-
% 	cexprogb E H S,!,
% 	term_to_string H HStr, term_to_string S SStr,
% 	print "at height: ", print HStr, print "   at size: ", print SStr, print "\n"
% 	;
% 	H1 is H  + 1, S1 is S + 1,
% 	drive_progb E H1 S1.
	
% cexpres E E' T :-
% %	check (pair (qgen (qheight 5)) (qgen (qsize 9 _))) (wt null E T),
% %	check (pair (qgen (qheight 4)) (qgen (qsize 8 _))) (is_exp' null E),
% 	check (qgen (qsize 10 _)) (wt null E T),
% %	check (qgen (qheight 6)) ( null E'),
% 	%check (qgen (qheight 1)) (is_ty T),
% 	interp (step E E'),
% 	interp (wt null E T),
% 	not (interp (wt null E' T)),
% 	!.

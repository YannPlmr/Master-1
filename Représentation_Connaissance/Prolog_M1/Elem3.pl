third(T, [T|_], 1) :- !.
third(Res, [T|Q], C):- C1 is C-1, third(Res, Q, C1). 
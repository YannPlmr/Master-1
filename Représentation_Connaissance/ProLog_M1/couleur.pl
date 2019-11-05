couleur(jaune).
couleur(vert).
couleur(rouge).

coloriage(A,B,C,D):-
couleur(A),
couleur(B),
couleur(C),
couleur(D),

A\=B, B\=C, C\=D, D\=A; C\=A.

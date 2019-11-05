couleur(rouge).
couleur(jaune).
couleur(vert).
couleur(bleu).

coloriage(A,B,C,D,E,F):- 
couleur(A),
couleur(B),
couleur(C),
couleur(D),
couleur(E),
couleur(F),

A\=B, A\=C, A\=F, A\=E, B\=E, B\=F, C\=D, E\=F. 

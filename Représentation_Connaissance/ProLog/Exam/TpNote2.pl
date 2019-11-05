longueur([],0).
longueur([_|Q],L2):- longueur(Q,L), L2 is L+1.


somme([],0).
somme([T|Q],S2):- somme(Q,S), S2 is S+T.



moyenne([],0).
moyenne(Lis,M2):- longueur(Lis,L), somme(Lis,S), M2 is S/L.



replique([],0,[]).
replique([T|Q],N,L):-		N2 is N-1, N2 \= 0, replique([T|Q],N2,[T|L]).
replique([_|Q],N,Res):- 	replique(Q,N,Res).
								






	
la(Arriver).
li(Intermediaire).
ld(Depart).
			
position(N,D,A,I).
position(N,D,A,I):- N2 is N-1, N\=0, position(N2,D,I,A), position(N2,I,A,D). 

hanoi(N):- la(A),
	   li(I),
	   ld(D),

	position(N,D,A,I), write('deplacement de '), write(A), write(' vers '), write(C), nl.


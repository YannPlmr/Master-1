substituer(X,Y,[],[]).
substituer(X,Y,[X|Q],[Y|Res]):- substituer(X,Y,Q,Res).
substituer(X,Y,[T|Q],[T|Res]):- substituer(X,Y,Q,Res).



supprimer(X,[],[]).
supprimer(X,[X|Q],Res):- supprimer(X,Q,Res).
supprimer(X,[T|Q],[T|Res]):- supprimer(X,Q,Res).



nombre_car([],X,0).
nombre_car([X|Q],X,N2):- nombre_car(Q,X,N), N2 is N+1.
nombre_car([_|Q],X,N):- nombre_car(Q,X,N).



max([],[]).
max([[T|Q2]|Q],Res):- max([Q|Q2],[T|Res]), T > Res.

minmax([],Res).
minmax([[T2|Q2]|Q],Res):- max(L,[T|Res]),T<Res.
/* Recherche des maximums de chaque sous listes que l on passe dans une nouvelle liste*/
/* Puis on cherche dans la liste des maximums, le minimum des maxi*/




R1=(1,_).
R2=(2,_).
R3=(3,_).
R4=(4,_).

reine(R1,R2,R3,R4):-   	

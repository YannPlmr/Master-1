mylast(T,[T|[]]).
mylast(Res,[T|Q]):- mylast(Res,Q). /*OK*/


mySlast(T,[T|[T2|[]]]).
mySlast(Res,[T|Q]):- mySlast(Res,Q). /*OK*/



myKelem(T,[T|_],0).
myKelem(Res,[T|Q],N):- N2 is N-1, myKelem(Res,Q,N2). /*OK*/



listnb(Res,[],Res).
listnb(Res,[_|Q],N):- N2 is N+1, listnb(Res,Q,N2). /*OK*/



reverselist(Res,[],Res).
reverselist(Res,[T|Q],Acc):- reverselist(Res,Q,[T|Acc]). /*OK*/



palyndrome(L):- reverselist(L,L,[]). /*OK*/




myflatten([],[]).
myflatten([T|Q],Res):- is_list(T), is_list(Q),
						myflatten(T,ResT),
						myflatten(Q,ResQ),
						append(ResT,ResQ,Res).
myflatten([T|Q],Res):- is_list(T),
						myflatten(T,ResT),
						append(ResT,[Q],Res).
myflatten([T|Q],Res):- is_list(Q),
						myflatten(Q,ResQ),
						append([T],ResQ,Res).		 /*OK*/				


						
						
compress([],[]).
compress([T],[T]).
compress([T,T|Q],Res):- compress([T|Q],Res).
compress([T1,T2|Q],[T1|Res]):- T1 \= T2, compress([T2|Q],Res). /*OK*/

pak([],[]).
pak([T,T|Q],Res):- pak([[T,T]|Q],Res).
pak([[T|Q1]|[T|Q2]],Res):- pak([[T,T|Q1]|Q2],Res).
pak([[T|Q],[[T]|Res]]):-
						not(is_list(T)),
						pak(Q,Res).
pak([T|Q],[T|Res]):- pak(Q,Res).    
/*OK*/



encode([],[]):- !.
encode([T|Q],[[X,T]|Res]):- pak([T|Q],T1),
						  length(T1,X),!, 
						  encode(Q,Res).























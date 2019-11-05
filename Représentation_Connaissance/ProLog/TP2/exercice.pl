ln([norvegien, _,_,_,_]).
lb([_,_,lait,_,_]).
lc([_,bleue,_,_,_]).
la([_,_,_,_,_]).
lp([_,_,_,_,_]).


meme_maison(X,[X|_],Y,[Y|_]).
meme_maison(X,[_|Q],Y,[_|Q2]):- meme_maison(X,Q,Y,Q2).

maison_a_cote(X,[X|_],Y,[_,Y|_]).
maison_a_cote(X,[_,X|_],Y,[Y|_]).
maison_a_cote(X,[_|Q],Y,[_|Q2]):- maison_a_cote(X,Q,Y,Q2).

maison_a_droite(X,Y,[X,Y|_]).
maison_a_droite(X,Y,[_|Q]):- maison_a_droite(X,Y,Q).

zebre(C,N,B,A,P,PossZebre,BoitVin):- 
					lc(C),
					lb(B),
					ln(N),
					la(A),
					lp(P),
					
					meme_maison(anglais,N,rouge,C),
					meme_maison(espagnol,N,chien,A),
					meme_maison(japonais,N,peintre,P),
					meme_maison(italien,N,the,B),
					meme_maison(vert,C,cafe,B),
					maison_a_droite(blanche,vert,C),
					meme_maison(sculpteur,P,escargot,A),
					meme_maison(diplomate,P,jaune,C),
					maison_a_cote(norvegien,N,bleue,C),
					meme_maison(violoniste,P,jusdefruit,B),
					maison_a_cote(renard,A,medecin,P),
					maison_a_cote(cheval,A,diplomate,P),

					meme_maison(zebre,A,PossZebre,N),
					meme_maison(vin,B,BoitVin,N).



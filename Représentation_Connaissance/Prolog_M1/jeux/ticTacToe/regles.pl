%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%# Le Tic-Tac-Toe
%#   -> representation.pl : module de représentation du jeu (affichage, manipulation de la grille, etc).
%#
%# Dependances :
%#   -> TicTacToe.pl : module principal qui charge tous les modules necessaires au deroulement du jeu. 
%#   -> regles.pl : module de modelisation des regles du jeu.
%#
%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#

%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%#%#%# gestion des directions
%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#

%# toutesLesCasesValides(Grille, LC1, C, LC2).
%# Se verifie si l'on peut jouer dans la case C de Grille et que la liste
%# LC1 est une liste composee de toutes les cases de LC2 et de C.
%# Permet de dire si la case C est une case ou l'on peut jouer, en evitant
%# de jouer deux fois dans la meme case.
toutesLesCasesValides(Grille, LC1, C, LC2) :-
	coordonneesOuListe(Col, Lig, C),
	leCoupEstValide(Col, Lig, Grille),
	duneListeALautre(LC1, C, LC2).
    
    %# Predicat : ligneFaite/2
    %#

    ligneFaite(Val, [Val]).
    ligneFaite(Val, [Val|R]) :- ligneFaite(Val, R).


    %# Predicat : ligneExiste/3
    %# ?- ligneExiste(x,[[x,-,x],[x,x,x],[-,o,-]],V).
    %# V = 2 ;

    ligneExiste(Val, [L1|_], 1) :- ligneFaite(Val, L1).
    ligneExiste(Val, [_|R], NumLigne) :- succNum(I,NumLigne), ligneExiste(Val, R, I).


    %# Predicat : colonneExiste/3
    colonneExiste(Val, [[Val|_],[Val|_],[Val|_]], a).
    colonneExiste(Val, [[_|R1],[_|R2],[_|R3]], NomCol) :-
    	succAlpha(I,NomCol),
    	colonneExiste(Val, [R1,R2,R3], I).


    %# Predicats diagonaleDG/2 et diagonaleGD/2
    diagonaleGD(Val, [[Val,_,_],[_,Val,_],[_,_,Val]]).
    diagonaleDG(Val, [[_,_,Val],[_,Val,_],[Val,_,_]]).


    %# Predicat partieGagnee/2
    partieGagnee(Val, G) :- ligneExiste(Val, G, _).
    partieGagnee(Val, G) :- colonneExiste(Val, G, _).
    partieGagnee(Val, G) :- diagonaleGD(Val, G).
    partieGagnee(Val, G) :- diagonaleDG(Val, G).

    %# Predicat : joueLeCoup/4
    joueLeCoup(Case, Valeur, GrilleDep, GrilleArr) :-
	coordonneesOuListe(Col, Lig, Case),
	leCoupEstValide(Col, Lig, GrilleDep),
	coupJoueDansGrille(Col, Lig, Valeur, GrilleDep, GrilleArr),
	nl, afficheGrille(GrilleArr), nl.

    %# Predicat : coupJoueDansLigne/4
    coupJoueDansLigne(a, Val, [-|Reste],[Val|Reste]).
    coupJoueDansLigne(NomCol, Val, [X|Reste1],[X|Reste2]):-
		succAlpha(I,NomCol),
		coupJoueDansLigne(I, Val, Reste1, Reste2).


    %# Predicat : coupJoueDansGrille/5
    coupJoueDansGrille(NCol,1,Val,[A|Reste],[B|Reste]):- coupJoueDansLigne(NCol, Val, A, B).
    coupJoueDansGrille(NCol, NLig, Val, [X|Reste1], [X|Reste2]):- succNum(I, NLig),
					coupJoueDansGrille(NCol, I, Val, Reste1, Reste2).

    %# Predicat : leCoupEstValide/3
    leCoupEstValide(C,L,G) :- caseDeGrille(C,L,G,-).
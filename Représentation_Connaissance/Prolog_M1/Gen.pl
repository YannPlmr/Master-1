%# Predicat : afficheLigne /1 
afficheLigne([]).
afficheLigne([T|Q]):- write(T), tab(3), afficheLigne(Q).

%# Predicat : afficheGrille/1
afficheGrille([]).
afficheGrille([T|Q]):- afficheLigne(T), nl, afficheGrille(Q). 



%# Predicat : ligneDeGrille(NumLigne, Grille, Ligne).
%# Satisfait si Ligne est la ligne numero NumLigne dans la Grille
ligneDeGrille(1, [Test |_], Test).
ligneDeGrille(NumLigne, [_|Reste],Test) :- succNum(I, NumLigne),
		ligneDeGrille(I,Reste,Test).

%# Predicat : caseDeLigne(Col, Liste, Valeur).
%# Satisfait si Valeur est dans la colonne Col de la Liste
caseDeLigne(a, [A|_],A).
caseDeLigne(Col, [_|Reste],Test) :- succAlpha(I, Col),caseDeLigne(I,Reste, Test).


%# Predicat : caseDeGrille(NumCol, NumLigne, Grille, Case).
%# Satisfait si Case est la case de la Grille en position NumCol-NumLigne
caseDeGrille(C,L,G, Elt) :- ligneDeGrille(L,G,Res),caseDeLigne(C,Res,Elt).


%# Predicat : afficheCaseDeGrille(Colonne,Ligne,Grille) .
afficheCaseDeGrille(C,L,G) :- caseDeGrille(C,L,G,Case),write(Case).


%# Predicat : leCoupEstValide/3
leCoupEstValide(C,L,G) :- caseDeGrille(C,L,G,-).


%# version recursive
coupJoueDansLigne(a, Val, [-|Reste],[Val|Reste]).
coupJoueDansLigne(NomCol, Val, [X|Reste1],[X|Reste2]):-
		succAlpha(I,NomCol),
		coupJoueDansLigne(I, Val, Reste1, Reste2).


%# Predicat : coupJoueDansGrille/5
coupJoueDansGrille(NCol,1,Val,[A|Reste],[B|Reste]):- coupJoueDansLigne(NCol, Val, A, B).
coupJoueDansGrille(NCol, NLig, Val, [X|Reste1], [X|Reste2]):- succNum(I, NLig),
					coupJoueDansGrille(NCol, I, Val, Reste1, Reste2).


%# coordonneesOuListe(NomCol, NumLigne, Liste).
%# ?- coordonneesOuListe(a, 2, [a,2]). vrai.
coordonneesOuListe(NomCol, NumLigne, [NomCol, NumLigne]).


%# duneListeALautre(LC1, Case, LC2)
%# ?- duneListeALautre([[a,1],[a,2],[a,3]], [a,2], [[a,1],[a,3]]). est vrai
duneListeALautre([A|B], A, B).
duneListeALautre([A|B], C, [A|D]):- duneListeALautre(B,C,D).


%# toutesLesCasesValides(Grille, LC1, C, LC2).
%# Se verifie si l'on peut jouer dans la case C de Grille et que la liste
%# LC1 est une liste composee de toutes les cases de LC2 et de C.
%# Permet de dire si la case C est une case ou l'on peut jouer, en evitant
%# de jouer deux fois dans la meme case.
toutesLesCasesValides(Grille, LC1, C, LC2) :-
	coordonneesOuListe(Col, Lig, C),
	leCoupEstValide(Col, Lig, Grille),
	duneListeALautre(LC1, C, LC2).

campCPU(x).


campAdverse(x,o).
campAdverse(o,x).

joueLeCoup(Case, Valeur, GrilleDep, GrilleArr) :-
	coordonneesOuListe(Col, Lig, Case),
	leCoupEstValide(Col, Lig, GrilleDep),
	coupJoueDansGrille(Col, Lig, Valeur, GrilleDep, GrilleArr),
	nl, afficheGrille(GrilleArr), nl.

saisieUnCoup(NomCol,NumLig) :-
	writeln("entrez le nom de la colonne a jouer (a,b,c) :"),
	read(NomCol), nl,
	writeln("entrez le numero de ligne a jouer (1, 2 ou 3) :"),
	read(NumLig),nl.



%# Predicat : moteur/3
%# Usage : moteur(Grille,ListeCoups,Camp) prend en parametre une grille dans
%# laquelle tous les coups sont jouables et pour laquelle
%# Camp doit jouer.


%# cas gagnant pour le joueur
moteur(Grille,_,Camp):-
	partieGagnee(Camp, Grille), nl,
	write('le camp '), write(Camp), write(' a gagne').

%# cas gagnant pour le joueur adverse
moteur(Grille,_,Camp):-
	campAdverse(CampGagnant, Camp),
	partieGagnee(CampGagnant, Grille), nl,
	write('le camp '), write(CampGagnant), write(' a gagne').

%# cas de match nul, plus de coups jouables possibles
moteur(_,[],_) :-nl, write('game over').

%# cas ou l ordinateur doit jouer
moteur(Grille, [Premier|ListeCoupsNew], Camp) :-
	campCPU(Camp),
	joueLeCoup(Premier, Camp, Grille, GrilleArr),
	campAdverse(AutreCamp, Camp),
	moteur(GrilleArr, ListeCoupsNew, AutreCamp).

%# cas ou c est l utilisateur qui joue
moteur(Grille, ListeCoups, Camp) :-
	campCPU(CPU),
	campAdverse(Camp, CPU),
	saisieUnCoup(Col,Lig),
	joueLeCoup([Col,Lig], Camp, Grille, GrilleArr),
	toutesLesCasesValides(Grille, ListeCoups, [Col, Lig], ListeCoupsNew),
	moteur(GrilleArr, ListeCoupsNew, CPU).


%# Predicat : lanceJeu/0
%# Usage :  lanceJeu permet de lancer une partie.

lanceJeu:-
  grilleDeDepart(G),
	toutesLesCasesDepart(ListeCoups),
	afficheGrille(G),nl,
   writeln("L ordinateur est les x et vous etes les o."),
   writeln("Quel camp doit debuter la partie ? "),read(Camp),
	toutesLesCasesDepart(ListeCoups),
	moteur(G,ListeCoups,Camp).



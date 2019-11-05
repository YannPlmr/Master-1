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
%#%#%#%#%#%#
%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#

%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%# Definition de la grille de depart de jeu
%# il n y a pas besoin de guillemets pour chaque element de la liste
grilleDeDepart([[-,-,-],
                [-,-,-],
                [-,-,-]]).

%# lister toutes les cases disponibles pour jouer
toutesLesCasesDepart([[a,1],[a,2],[a,3],
                     [b,1],[b,2],[b,3],
                     [c,1],[c,2],[c,3]]).

%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%# Predicat : succNum/2
%# Usage : succNum(X,Y) est satisfait si Y est le successeur de X
succNum(1,2).
succNum(2,3).

%# Predicat : succAlpha/2
%# Usage : succAlpha(X,Y) est satisfait si Y est le successeur de X 
%#	 (ordre lexico-graphique)
succAlpha(a,b).
succAlpha(b,c).
	

%# Predicat : afficheCaseDeGrille(Colonne,Ligne,Grille) .
afficheCaseDeGrille(C,L,G) :- caseDeGrille(C,L,G,Case),write(Case).

%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#

%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%# Predicat : saisieUnCoup/2
%# Usage : saisieUnCoup(NomCol,NumLig) permet de saisir un coup a jouer

saisieUnCoup(NomCol,NumLig) :-
	writeln("entrez le nom de la colonne a jouer (a,b,c) :"),
	read(NomCol), nl,
	writeln("entrez le numero de ligne a jouer (1, 2 ou 3) :"),
	read(NumLig),nl.

%# on peut affiner le predicat en testant les valeurs donnees par l utilisateur avec
%# saisieColonne et saisieLigne.

%# Predicat : saisieColonne/1
%# Usage : saisieColonne(NomCol) permet d eviter les erreurs de saisie de la colonne
saisieColonne(NomCol):-
	read(NomCol),
	member(NomCol,[a,b,c]),!.

saisieColonne(NomCol):-
	writeln('Nom de colonne incorrect'),
	writeln('Colonne (a, b ou c) : '),
	saisieColonne(NomCol).


%# Predicat : saisieLigne/1
%# Usage : saisieLigne(NumLig) permet d eviter les erreurs de saisie de la ligne

saisieLigne(NumLig):-
	read(NumLig),
	member(NumLig,[1,2,3]),!.

saisieLigne(NumLig):-
	writeln('Coup invalide'),
	saisieUnCoup(_NomCol,NumLig).
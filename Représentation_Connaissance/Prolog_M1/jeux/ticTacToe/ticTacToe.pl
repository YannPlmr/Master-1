%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%# Le Tic-Tac-Toe
%#   -> representation.pl : module de représentation du jeu (affichage, manipulation de la grille, etc).
%#
%# Dependances :
%#   -> TicTacToe.pl : module principal qui charge tous les modules necessaires au deroulement du jeu. 
%#   -> regles.pl : module de modelisation des regles du jeu.
%#
%#
%# Pour lancer le jeu : 
%#  ?- consult(TicTacToe).
%#  ?- lanceJeu.
%#
%#
%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#


%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%# Permet de separer les predicats en differents fichiers selon leur role.
%# Appelle le predicat consult/1 directement dans le fichier pour charger les
%#   faits et les regles ecrits dans les autres fichiers.
loadModulesTTT:-
   consult(mainRepresentation),
   consult(ticTacToe/representation),
   consult(ticTacToe/regles).


campCPU(x).

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

lanceTTT:-
	loadModulesTTT,
  	grilleDeDepart(G),
	toutesLesCasesDepart(ListeCoups),
	afficheGrille(G),nl,
   	writeln("L ordinateur est les x et vous etes les o."),
   	writeln("Quel camp doit debuter la partie ? "),read(Camp),
	toutesLesCasesDepart(ListeCoups),
	moteur(G,ListeCoups,Camp).



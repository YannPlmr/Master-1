%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%# Launcher
%#   -> launcher.pl : module de lancement des jeux a 2 joueurs.
%#
%# Dependances :
%#   -> TicTacToe.pl : module principal qui charge tous les modules necessaires au deroulement du jeu. 
%#   -> othello.pl : module principal qui charge tous les modules necessaires au deroulement du jeu. 
%#
%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#

%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%# Permet de separer les predicats en differents fichiers selon leur role.
%# Appelle le predicat consult/1 directement dans le fichier pour charger les
%#   faits et les regles ecrits dans les autres fichiers.
mainModules:-
   consult(ticTacToe/ticTacToe),
   consult(othello/othello).

lanceJeu:-
    mainModules,
	menuLauncher,!.

%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
%# Predicat : menuPrincipal/0
%# Usage : menuPrincipal est le menu principal du jeu

menuLauncher:-
	tab(8),writeln('Menu Principal'),
	tab(8),writeln('--------------'),
	tab(6),writeln('1 - TicTacToe'),
    tab(6),writeln('2 - Othello'),
	%# on pourra rajouter ici la possibilite de jouer contre l ordinateur
	tab(6),writeln('0 - Quitter'),
	saisieMainChoix(Choix),
	mainChoix(Choix),!.

%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
saisieMainChoix(Choix):-
	writeln('Choisissez une option (sans oublier le point) : '),
	read(Choix).

%#%#%# choix de sortir du programme
mainChoix(0):-
	tab(10),writeln('A tres bientot...'),!.

%#%#%# choix de lancer le jeu TicTacToe
mainChoix(1):-
    lanceTTT.

%#%#%# choix de lancer le jeu Othello
mainChoix(2):-
    lanceO.
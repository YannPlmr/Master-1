/*Module de représentation du jeu, avec la définition des prédicats de
 manipulation de la grille de jeu*/

case_plateau('-').
case_plateau('X').
case_plateau('O').

GrilleKono([['X','X','X','X'],['X','X','X','X'],['O','O','O','O'],['O','O','O','O']]).
GrilleTTT([['-','-','-'],['-','-','-'],['-','-','-']]).

grilleDeDepart(+Grille):- GrilleKono(+Grille); GrilleTTT(+Grille).

succNum(?Val1, ?Val2):-

succAlpha(?Alpha1, ?Alpha2):-

afficherGrille(+Grille):-

ligneDansGrille(+NumLigne, +Grille, ?Ligne):-

caseDansLigne(+Col, +Liste, ?Ligne):-

donneValeurDeCase(+Grille, +NumColonne, +NulLigne, ?Valeur):-

caseVide(+Grille, +NumColonne, +NulLigne):-

%# Marchand Killian

%# ======= MODIFIER ========
% Predicat : afficheLigne/1
afficheLigne([A,B,C,D,E]) :-
	write(A), tab(3),
	write(B), tab(3),
	write(C), tab(3),
    write(D), tab(3),
    write(E), tab(3).

%# ======= MODIFIER ========
% Predicat : afficheGrille/1
afficheGrille([[A1,B1,C1,D1,E1],[A2,B2,C2,D2,E2],[A3,B3,C3,D3,E3],[A4,B4,C4,D4,E4],[A5,B5,C5,D5,E5]]) :-
	afficheLigne([A1,B1,C1,D1,E1]), nl,
	afficheLigne([A2,B2,C2,D2,E2]), nl,
	afficheLigne([A3,B3,C3,D3,E3]), nl,
    afficheLigne([A4,B4,C4,D4,E4]), nl,
    afficheLigne([A5,B5,C5,D5,E5]), nl.

%# ======= MODIFIER ========
% Predicat : succNum/2
succNum(1,2).
succNum(2,3).
succNum(3,4).
succNum(4,5).

%# ======= MODIFIER ========
% Predicat : succAlpha/2
succAlpha(a,b).
succAlpha(b,c).
succAlpha(c,d).
succAlpha(d,e).


% Predicat : ligneDeGrille(NumLigne, Grille, Ligne).
% Satisfait si Ligne est la ligne numero NumLigne dans la Grille
ligneDeGrille(1, [Test |_], Test).
ligneDeGrille(NumLigne, [_|Reste],Test) :- succNum(I, NumLigne),
		ligneDeGrille(I,Reste,Test).

% Predicat : caseDeLigne(Col, Liste, Valeur).
% Satisfait si Valeur est dans la colonne Col de la Liste
caseDeLigne(a, [A|_],A).
caseDeLigne(Col, [_|Reste],Test) :- succAlpha(I, Col),caseDeLigne(I,Reste, Test).


% Predicat : caseDeGrille(NumCol, NumLigne, Grille, Case).
% Satisfait si Case est la case de la Grille en position NumCol-NumLigne
caseDeGrille(C,L,G, Elt) :- ligneDeGrille(L,G,Res),caseDeLigne(C,Res,Elt).


% Predicat : afficheCaseDeGrille(Colonne,Ligne,Grille) .
afficheCaseDeGrille(C,L,G) :- caseDeGrille(C,L,G,Case),write(Case).


% Predicat : leCoupEstValide/3
leCoupEstValide(C,L,G) :- caseDeGrille(C,L,G,-).


% Predicat : coupJoueDansLigne/4
% version recursive
coupJoueDansLigne(a, Val, [-|Reste],[Val|Reste]).
coupJoueDansLigne(NomCol, Val, [X|Reste1],[X|Reste2]):-
		succAlpha(I,NomCol),
		coupJoueDansLigne(I, Val, Reste1, Reste2).


% Predicat : coupJoueDansGrille/5
coupJoueDansGrille(NCol,1,Val,[A|Reste],[B|Reste]):- coupJoueDansLigne(NCol, Val, A, B).
coupJoueDansGrille(NCol, NLig, Val, [X|Reste1], [X|Reste2]):- succNum(I, NLig),
					coupJoueDansGrille(NCol, I, Val, Reste1, Reste2).

%# ======= MODIFIER ========
%# ===== Version BOF =======
succAlpha(b,c).
% Predicat : ligneFaite/2
%
% version bof
% ligneFaiteBof(x,[x,x,x,x,x]).
% ligneFaiteBof(o,[o,o,o,o,o]).
% ligneFaiteBof(-,[-,-,-,-,-]).
ligneFaite(Val, [Val]).
ligneFaite(Val, [Val|R]) :- ligneFaite(Val, R).


% Predicat : ligneExiste/3
% ?- ligneExiste(x,[[x,-,x],[x,x,x],[-,o,-]],V).
% V = 2 ;

ligneExiste(Val, [L1|_], 1) :- ligneFaite(Val, L1).
ligneExiste(Val, [_|R], NumLigne) :- succNum(I,NumLigne), ligneExiste(Val, R, I).

%# ======= MODIFIER ========
% Predicat : colonneExiste/3
colonneExiste(Val, [[Val|_],[Val|_],[Val|_],[Val|_],[Val|_]], a).
colonneExiste(Val, [[_|R1],[_|R2],[_|R3],[_|R4],[_|R5]], NomCol) :-
	succAlpha(I,NomCol),
	colonneExiste(Val, [R1,R2,R3,R4,R5], I).

%# ======= MODIFIER ========
% Predicats diagonaleDG/2 et diagonaleGD/2
diagonaleGD(Val, [[Val,_,_,_,_],[_,Val,_,_,_],[_,_,Val,_,_],[_,_,_,Val,_],[_,_,_,_,Val]]).
diagonaleDG(Val, [[_,_,_,_,Val],[_,_,_,Val,_],[_,_,Val,_,_],[_,Val,_,_,_],[Val,_,_,_,_]]).


% Predicat partieGagnee/2
partieGagnee(Val, G) :- ligneExiste(Val, G, _).
partieGagnee(Val, G) :- colonneExiste(Val, G, _).
partieGagnee(Val, G) :- diagonaleGD(Val, G).
partieGagnee(Val, G) :- diagonaleDG(Val, G).


% coordonneesOuListe(NomCol, NumLigne, Liste).
% ?- coordonneesOuListe(a, 2, [a,2]). vrai.
coordonneesOuListe(NomCol, NumLigne, [NomCol, NumLigne]).

%# ======= MODIFIER ========
% duneListeALautre(LC1, Case, LC2)
% ?- duneListeALautre([[a,1],[a,2],[a,3],[a,4],[a,5]], [a,2], [[a,1],[a,3],[a,4],[a,5]]). est vrai
duneListeALautre([A|B], A, B).
duneListeALautre([A|B], C, [A|D]):- duneListeALautre(B,C,D).


% toutesLesCasesValides(Grille, LC1, C, LC2).
% Se verifie si l'on peut jouer dans la case C de Grille et que la liste
% LC1 est une liste composee de toutes les cases de LC2 et de C.
% Permet de dire si la case C est une case ou l'on peut jouer, en evitant
% de jouer deux fois dans la meme case.
toutesLesCasesValides(Grille, LC1, C, LC2) :-
	coordonneesOuListe(Col, Lig, C),
	leCoupEstValide(Col, Lig, Grille),
	duneListeALautre(LC1, C, LC2).

%# ======= MODIFIER ========
toutesLesCasesDepart([[a,1],[a,2],[a,3],[a,4],[a,5],[b,1],[b,2],[b,3],[b,4],[b,5],[c,1],[c,2],[c,3],[c,4],[c,5],[d,1],[d,2],[d,3],[d,4],[d,5],[e,1],[e,2],[e,3],[e,4],[e,5]]).

%# ======= MODIFIER ========
grilleDeDepart([[-,-,-,-,-],[-,-,-,-,-],[-,-,-,-,-],[-,-,-,-,-],[-,-,-,-,-]]).

%# ======= MODIFIER ========
campCPU(x).
campCPU2(o).


campAdverse(x,o).
campAdverse(o,x).

joueLeCoup(Case, Valeur, GrilleDep, GrilleArr) :-
	coordonneesOuListe(Col, Lig, Case),
	leCoupEstValide(Col, Lig, GrilleDep),
	coupJoueDansGrille(Col, Lig, Valeur, GrilleDep, GrilleArr),
	nl, afficheGrille(GrilleArr), nl.

%# ======= MODIFIER ========
ù saisieUnCoup(NomCol,NumLig) :-
%	writeln("entrez le nom de la colonne a jouer (a,b,c, d ou e) :"),
%	read(NomCol), nl,
%	writeln("entrez le numero de ligne a jouer (1, 2,3, 4 ou 5) :"),
%	read(NumLig),nl.

% saisieUnCoupValide(Col,Lig,Grille):-
%	saisieUnCoup(Col,Lig),
%	leCoupEstValide(Col,Lig,Grille),
%	writef('attention, vous ne pouvez pas jouer dans cette case'), nl,
%	writef('reessayer SVP dans une autre case'),nl,
%	saisieUnCoupValide(Col,Lig,Grille).


% Predicat : moteur/3
% Usage : moteur(Grille,ListeCoups,Camp) prend en parametre une grille dans
% laquelle tous les coups sont jouables et pour laquelle
% Camp doit jouer.


% cas gagnant pour le joueur
moteur(Grille,_,Camp):-
	partieGagnee(Camp, Grille), nl,
	write('le camp '), write(Camp), write(' a gagne').

% cas gagnant pour le joueur adverse
moteur(Grille,_,Camp):-
	campAdverse(CampGagnant, Camp),
	partieGagnee(CampGagnant, Grille), nl,
	write('le camp '), write(CampGagnant), write(' a gagne').

% cas de match nul, plus de coups jouables possibles
moteur(_,[],_) :-nl, write('game over').

% cas ou l ordinateur doit jouer
moteur(Grille, [Premier|ListeCoupsNew], Camp) :-
	campCPU(Camp),
	joueLeCoup(Premier, Camp, Grille, GrilleArr),
	campAdverse(AutreCamp, Camp),
	moteur(GrilleArr, ListeCoupsNew, AutreCamp).

%# ======= MODIFIER ========

% cas ou l ordinateur2 doit jouer
moteur(Grille, [Premier|ListeCoupsNew], Camp) :-
	campCPU2(Camp),
	joueLeCoup(Premier, Camp, Grille, GrilleArr),
	campAdverse(AutreCamp, Camp),
	moteur(GrilleArr, ListeCoupsNew, AutreCamp).

% cas ou c est l utilisateur qui joue
% moteur(Grille, ListeCoups, Camp) :-
%	campCPU(CPU),
%	campAdverse(Camp, CPU),
%	saisieUnCoup(Col,Lig),
%	joueLeCoup([Col,Lig], Camp, Grille, GrilleArr),
%	toutesLesCasesValides(Grille, ListeCoups, [Col, Lig], ListeCoupsNew),
%	moteur(GrilleArr, ListeCoupsNew, CPU).


% Predicat : lanceJeu/0
% Usage :  lanceJeu permet de lancer une partie.

%# ======= MODIFIER ========
lanceJeu:-
  grilleDeDepart(G),
	toutesLesCasesDepart(ListeCoups),
	afficheGrille(G),nl,
   % writeln("L ordinateur est les x et vous etes les o."),
   % writeln("Quel camp doit debuter la partie ? "),read(Camp),
	toutesLesCasesDepart(ListeCoups),
	moteur(G,ListeCoups,Camp).



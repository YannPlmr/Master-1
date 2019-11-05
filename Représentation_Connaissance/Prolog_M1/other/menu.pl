/*les entrées*/
entree(crudites).
entree(terrine).
entree(melon).

/*Les viandes (avec legumes associés)*/
viande(steack).
viande(poulet).
viande(gigot).

/*Les poissons (avec legumes associés)*/
poisson(bar).
poisson(saumon).

/*les dessert*/
dessert(sorbet).
dessert(creme).
dessert(tarte).

/*Composition d un menu simple: une entreeRee ET un plat ET un dessert*/
menusimple(E,P,D):- entree(E), plat(P), dessert(D).

/*plat de réseistance: viande OU poisson*/
plat(P) :- viande(P).
plat(P) :- poisson(P).

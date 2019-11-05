/*Rappel:
	Nous avons notre ressource critique -> cpt (notre compteur)
	Pour mettre en place l'algo de Deckker nous avons besion de 2 variables.
		Une variable tour : qui détermine le tour de chaque processus.
		Une seconde variable veux_entrer : qui est un tableau des N processus qui permet de savoir si le processus N veut entrer et utiliser son temps.
	C'est deux variables sont initialement enregistré dans le SMP (Segment Mémoire Partagé) par projection entre les deux processus dans cet exemple.

	/!\ L'algorithme de Deckker fonctionne très bien pour les machien à 1 processus(coeur). Si il y a plusiseurs processus(coeurs),  nous retombons sur des valeurs fausses.
	Les valeurs enregistrées en cache des différents processus se mélangent entre elles, ce qui cause les différentes erreurs.

	C'est ici qu'interviennent les sémaphores. 

*/

/*Aperçu algo_deckker*/

void Processus_1(){
	/*ENTRER dans la section critique*/
	veux_entrer[P1] = TRUE;
	while(veux_entrer[P2]){
		if(tour == P2){
			veux_entrer[P1] = FALSE;
			while(tour != P2){}
			veux_entrer[P1] = TRUE;
		}

	}

	/*Section Critique*/
	cpt++;

	/*Sortie Section Critique*/
	veux_entrer[P1] = FALSE;
	tour = P2;
}

void Processus_2(){
	/*ENTRER dans la section critique*/
	veux_entrer[P2] = TRUE;
	while(veux_entrer[P1]){
		if(tour == P1){
			veux_entrer[P2] = FALSE;
			while(tour != P1){}
			veux_entrer[P2] = TRUE;
		}

	}

	/*Section Critique*/
	cpt++;

	/*Sortie Section Critique*/
	veux_entrer[P2] = FALSE;
	tour = P1;
}
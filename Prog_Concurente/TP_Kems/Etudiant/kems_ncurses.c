#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

#include <sys/types.h>
#include <sys/ipc.h>

#include <ncurses.h>

#include <commun.h>
#include <paquet.h>
#include <tapis.h>
#include <ecran.h>

#include <pthread.h>


/* GLOBALS */

  paquet_t * paquet = PAQUET_NULL ;
  tapis_t * tapis_central = TAPIS_NULL ;
  tapis_t ** tapis = NULL ; /* tableau des tapis */

  err_t cr = OK ;

  carte_id_t c = -1 ;

  int nbJoueur = 0;

  booleen_t fini = FAUX;

  char mess[256] ; 
  ecran_t * ecran = NULL ; 

  

	/* Mutex */
	pthread_mutex_t mCompt = PTHREAD_MUTEX_INITIALIZER;

	pthread_mutex_t mTapis = PTHREAD_MUTEX_INITIALIZER;
	
	pthread_mutex_t mCarte1 = PTHREAD_MUTEX_INITIALIZER;
	pthread_mutex_t mCarte2 = PTHREAD_MUTEX_INITIALIZER;
	pthread_mutex_t mCarte3 = PTHREAD_MUTEX_INITIALIZER;
	pthread_mutex_t mCarte4 = PTHREAD_MUTEX_INITIALIZER;

	pthread_mutex_t mFini = PTHREAD_MUTEX_INITIALIZER;

	pthread_mutex_t mT = PTHREAD_MUTEX_INITIALIZER;
  pthread_mutex_t mEcran = PTHREAD_MUTEX_INITIALIZER;

void arret( int sig ){
  /* printf( "Arret utilisateur\n");*/
} 

//Processus Joueur
//Chaque joueur créé sera un thread par la suite
void Joueur(int i){

    carte_id_t ind_carte = -1 ;
    carte_id_t ind_carte_central = -1 ;

    booleen_t echange = FAUX;
    fini = FAUX;
    int id;

	pthread_mutex_lock(&mFini);
    while(!fini){
		pthread_mutex_unlock(&mFini);

      id = i;

      /* Test arret */
      if( tapis_carre( tapis[i] ) ){

			  pthread_mutex_lock(&mFini);
        fini = VRAI ;
		  	pthread_mutex_unlock(&mFini);

        fini = VRAI ;
	      sprintf( mess ,  "Le joueur %2d a gagne" , i ) ; 
        pthread_mutex_lock(&mEcran);
	      ecran_message_pause_afficher( ecran , mess ) ;
        pthread_mutex_unlock(&mEcran); 
	      goto fin ;
        }

		pthread_mutex_lock(&mCompt);
		nbJoueur++;
		if(nbJoueur == 1) pthread_mutex_lock(&mTapis);
		pthread_mutex_unlock(&mCompt);

		pthread_mutex_lock(&mT);

        if( ( cr = tapis_cartes_choisir( &echange , tapis[i] , &ind_carte , tapis_central , &ind_carte_central) ) ){
          sprintf( mess , "Pb dans choix des cartes, code retour = %d\n", cr ) ;
	        pthread_mutex_lock(&mEcran);
	        ecran_message_pause_afficher( ecran , mess ) ;
          pthread_mutex_unlock(&mEcran);
          erreur_afficher(cr) ;
	        goto fin ;
        }

		pthread_mutex_unlock(&mT);

        if( echange ){
			
			id = ind_carte_central;
			switch (id){
			case 0: pthread_mutex_lock(&mCarte1);
				break;
			case 1: pthread_mutex_lock(&mCarte2);
				break;
			case 2: pthread_mutex_lock(&mCarte3);
				break;		
			case 3: pthread_mutex_lock(&mCarte4);
				break;
			}
			

            if( ( cr = tapis_cartes_echanger( tapis[i] , ind_carte , tapis_central , ind_carte_central ) ) ){
              sprintf( mess, "Pb d'echange de cartes entre la carte %ld du tapis du joueur %d et la carte %ld du tapis central" , ind_carte , i , ind_carte_central ); 
              pthread_mutex_lock(&mEcran);
              ecran_message_pause_afficher( ecran , mess ) ;
              pthread_mutex_unlock(&mEcran); 
              erreur_afficher(cr) ; 
              goto fin ; 
            }
            sprintf( mess , "Joueur %i: Echange carte %ld avec carte %ld du tapis central " , i , ind_carte , ind_carte_central ) ;
	          pthread_mutex_lock(&mEcran);
            ecran_message_pause_afficher( ecran , mess ) ; 
	          ecran_cartes_echanger( ecran , 
				    f_tapis_f_carte_lire( ecran_tapis_central_lire( ecran ) , ind_carte_central ) ,
				    f_tapis_f_carte_lire( ecran_tapis_joueur_lire( ecran , i ) , ind_carte ) ) ;
	          ecran_afficher( ecran , tapis_central , tapis ) ; 
	          ecran_message_effacer( ecran ) ;
            pthread_mutex_unlock(&mEcran);

			id = ind_carte_central;
			switch (id){
			case 0: pthread_mutex_unlock(&mCarte1);
				break;
			case 1: pthread_mutex_unlock(&mCarte2);
				break;
			case 2: pthread_mutex_unlock(&mCarte3);
				break;		
			case 3: pthread_mutex_unlock(&mCarte4);
				break;
			}
	    }

		pthread_mutex_lock(&mCompt);
		nbJoueur--;
		if(nbJoueur == 0) pthread_mutex_unlock(&mTapis);
		pthread_mutex_unlock(&mCompt);


    }
}


//Processus Tapis

void Tapis(){

	pthread_mutex_lock(&mFini);
    while(!fini){
		pthread_mutex_unlock(&mFini);


    pthread_mutex_lock(&mEcran);
		pthread_mutex_lock(&mTapis);
		/*
		* Pas un seul echange des joueur
		* --> redistribution du tapis central
		*/
		ecran_message_pause_afficher( ecran , "Pas d'echange --> Redistribution tapis central") ; 
	  for( c=0 ; c<TAPIS_NB_CARTES ; c++ ){
	      if( ( cr = tapis_carte_retirer( tapis_central , c , paquet ) ) ){
          ecran_message_pause_afficher(ecran , "Pb dans retrait d'une carte du tapis central" ); 
          erreur_afficher(cr) ; 
          goto fin ; 
        }
	  
	      if( ( cr = tapis_carte_distribuer( tapis_central , c , paquet ) ) ){
          ecran_message_pause_afficher( ecran , "Pb dans distribution d'une carte pour le tapis central" ); 
          erreur_afficher(cr) ; 
          goto fin ; 
        }
	  }
  	ecran_afficher( ecran  , tapis_central , tapis ) ;
  	ecran_message_effacer(ecran) ; 

		pthread_mutex_unlock(&mTapis);
    pthread_mutex_unlock(&mEcran);
	}
}

int main( int argc , char * argv[] ){

  tapis_id_t t=0;
  int i;

	printf("\n\n\n\t===========Debut %s==========\n\n" , argv[0] );

	if( argc != 2 ){
		printf( " Programme de test des joueurs de Kems\n" );
		printf( " usage : %s <Nb joueurs>\n" , argv[0] );
		exit(0);
	}

	if(atoi( argv[1] ) <= 0){
		printf( " Nombre de joueurs insuffisant ! \n" );
		exit(0);
	}

	int NbJoueurs = atoi(argv[1]) ;
 
  /* Creation du paquet */
  printf("Creation du paquet..." ) ; fflush(stdout) ; 
  paquet = paquet_creer() ; 
  printf( "OK\n"); 

  /* Creation tapis central */
  printf("Creation du tapis central...")  ; fflush(stdout) ; 
  if( ( tapis_central = tapis_creer() ) == TAPIS_NULL )
    {
      printf("Erreur sur creation du tapis central\n" ) ;
      exit(-1) ;
    }

  for( c=0 ; c<TAPIS_NB_CARTES ; c++ )
    {
      if( ( cr = tapis_carte_distribuer( tapis_central  , c , paquet ) ) )
	{
	  erreur_afficher(cr) ; 
	  exit(-1) ; 
	}
    }
  printf("OK\n"); 

  /* Creation des tapis des joueurs */
  printf("Creations des %d tapis..." , NbJoueurs ) ; fflush(stdout) ; 

  if( ( tapis = malloc( sizeof(tapis_t *) * NbJoueurs ) ) == NULL )
    {
      printf(" Erreur allocation memoire tableau des tapis (%lu octets demandes)\n" , 
	     (long unsigned int)(sizeof(tapis_t *) * NbJoueurs) ) ;
      exit(-1) ; 
    }

  for( t=0 ; t<NbJoueurs ; t++ ) 
    {

      if( ( tapis[t] = tapis_creer() ) == TAPIS_NULL )
	{
	  printf("Erreur sur creation du tapis %ld\n" , t ) ;
	  exit(-1) ;
	}

      for( c=0 ; c<TAPIS_NB_CARTES ; c++ )
	{
	  if( ( cr = tapis_carte_distribuer( tapis[t]  , c , paquet ) ) )
	    {
	      if( cr == ERR_PAQUET_VIDE ) printf("Pas assez de cartes pour tous les joueurs\n"); 
	      erreur_afficher(cr) ; 
	      exit(-1) ; 
	    }
	}
    }
  printf( "OK\n") ; 

  /*
   * Creation et affichage de l'ecran  
   */

  if( ( ecran = ecran_creer( tapis_central , 
			     tapis , 
			     NbJoueurs ) ) == NULL ) 
    {
      printf("Erreur sur la creation de l'ecran\n"); 
      exit(-1) ;
    }

  ecran_message_afficher( ecran , "Debut de partie: ^C pour commencer");
  pause() ; 

	int nThread = NbJoueurs + 1;

	pthread_t tThread[nThread];

	for(i = 0; i<NbJoueurs; i++){ pthread_create(&tThread[i], NULL, (void *)Joueur, i);}

	pthread_create(&tThread[nThread - 1], NULL, (void *)Tapis, (void *)NULL);

	for(i = 0; i<nThread; i++){ pthread_join(tThread[i], NULL);}


  /* Destruction de l'ecran */
  if( ( cr = ecran_detruire( &ecran ) ) ){
      fprintf( stderr , "Erreur lors de la destruction de l'ecran, cr = %d\n" , cr ) ;
      exit(-1) ; 
  }

  /* Destructions du tapis central */
  printf( "Destructions du tapis central...") ; fflush(stdout) ; 
  if( ( cr = tapis_detruire( &tapis_central ) ) ){
      fprintf( stderr , " Erreur sur destruction du tapis central\n") ;
      erreur_afficher(cr) ; 
      exit(-1) ; 
  }
  printf("OK\n"); 
  
  /* Destructions des tapis des joueurs */
  printf( "Destructions des tapis des joueurs...") ; fflush(stdout) ; 
  for( t=0 ; t<NbJoueurs ; t++ ){

      if( ( cr = tapis_detruire( &tapis[t] ) ) ){
	      fprintf( stderr , " Erreur sur destruction du tapis %ld\n"  , t ) ;
	      erreur_afficher(cr) ; 
	      exit(-1) ; 
     }
  }
  free( tapis ) ;
  printf("OK\n"); 

  /*  Destruction du paquet */
  printf("\nDestruction du paquet..." ) ; fflush(stdout) ; 
  if( ( cr = paquet_detruire( &paquet ) ) ){
    fprintf( stderr , " Erreur sur destruction du paquet\n" ) ;
    erreur_afficher(cr) ; 
    exit(-1) ; 
  }
  printf("OK\n") ; 
 
  printf("\n\n\t===========Fin %s==========\n\n" , argv[0] );

	pthread_mutex_destroy(&mFini);
	pthread_mutex_destroy(&mTapis);
	pthread_mutex_destroy(&mT);
	pthread_mutex_destroy(&mCompt);
	pthread_mutex_destroy(&mCarte1);
	pthread_mutex_destroy(&mCarte2);
	pthread_mutex_destroy(&mCarte3);
	pthread_mutex_destroy(&mCarte4);

	return 0;
}
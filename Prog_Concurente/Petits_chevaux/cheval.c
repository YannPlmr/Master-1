#include <stdio.h>
#include <stdlib.h>
#include <sys/msg.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>

#include <commun.h>
#include <liste.h>
#include <piste.h>

void P(int semid, int i){
  struct sembuf op_P2 = {i,-1,0};
  semop(semid, &op_P2, 1);
}

void V(int semid, int i){
  struct sembuf op_V2 = {i,1,0};
  semop(semid, &op_V2, 1);
}

int
main( int nb_arg , char * tab_arg[] ){

  int cle_piste ;
  piste_t * piste = NULL ;

  int cle_liste ;

  liste_t * liste = NULL ;

  char marque ;

  booleen_t fini = FAUX ;
  piste_id_t deplacement = 0 ;
  piste_id_t depart = 0 ;
  piste_id_t arrivee = 0 ;


  cell_t cell_cheval ;


  elem_t elem_cheval ;



  /*-----*/

  if( nb_arg != 4 )
    {
      fprintf( stderr, "usage : %s <cle de piste> <cle de liste> <marque>\n" , tab_arg[0] );
      exit(-1);
    }

  if( sscanf( tab_arg[1] , "%d" , &cle_piste) != 1 )
    {
      fprintf( stderr, "%s : erreur , mauvaise cle de piste (%s)\n" ,
	       tab_arg[0]  , tab_arg[1] );
      exit(-2);
    }


  if( sscanf( tab_arg[2] , "%d" , &cle_liste) != 1 )
    {
      fprintf( stderr, "%s : erreur , mauvaise cle de liste (%s)\n" ,
	       tab_arg[0]  , tab_arg[2] );
      exit(-2);
    }

  if( sscanf( tab_arg[3] , "%c" , &marque) != 1 )
    {
      fprintf( stderr, "%s : erreur , mauvaise marque de cheval (%s)\n" ,
	       tab_arg[0]  , tab_arg[3] );
      exit(-2);
    }


/*==================================*/
/*  Debut_Phase_Créa_&_Init         */
/*==================================*/

  int id_liste_cheval;

  int shmid_liste;
  int shmid_piste;

  int semid_liste;
  int semid_piste;
  
  /*================================================================*/
  /*  Initialisation des SHM de la piste et de la liste de chevaux  */
  /*================================================================*/

    if((shmid_liste = shmget(cle_liste, sizeof(liste_t), 0666)) == (int)-1 ){
      fprintf( stderr, "Problème de création shm liste de cheval !\n" );
      exit(-1);
    }
    liste = shmat(shmid_liste, 0, 0);

    if((shmid_piste = shmget(cle_piste, sizeof(piste_t), 0666)) == (int)-1 ){
      fprintf( stderr, "Problème de création shm de la piste !\n" );
      exit(-1);
    }
    piste = shmat(shmid_piste, 0, 0);

  /*==========================================================*/
  /*  Initialisation de la piste et de la liste de chevaux    */
  /*==========================================================*/
    
    if( liste_initialiser( liste ) == (int)-1 ){
      fprintf( stderr, "Problème intialisation de la liste !\n" );
      exit(-1);
    }

    if( piste_initialiser( piste ) == (int)-1 ){
      fprintf( stderr, "Problème intialisation de la piste !\n" );
      exit(-1);
    }

  /*=====================================================================*/
  /*  Initialisation des Semaphore de la piste et de la liste de chevaux */
  /*=====================================================================*/
  
    semid_liste = semget(cle_liste, LISTE_MAX*(sizeof(elem_t)), 0666);
   

    semid_piste = semget(cle_piste, PISTE_LONGUEUR*(sizeof(cell_t)), 0666);

    /* Init de l'attente */
  commun_initialiser_attentes() ;

  /* Init de la cellule du cheval pour faire la course */
  cell_pid_affecter( &cell_cheval  , getpid());
  cell_marque_affecter( &cell_cheval , marque );

  /* Init de l'element du cheval pour l'enregistrement */
  elem_cell_affecter(&elem_cheval , cell_cheval ) ;
  elem_etat_affecter(&elem_cheval , EN_COURSE ) ;
    

  /*
  * Enregistrement du cheval dans la liste
  */

  /*==========================================================*/
  /*           Ajout d'éléments dans la liste                 */
  /*   Verrouillage et deverouillage de la liste (semaphore)  */
  /*           Création d'un semaphore cheval                 */
  /*==========================================================*/

    struct sembuf op_P = {0,-1,0};
    struct sembuf op_V = {0,1,0};

    semop(semid_liste, &op_P,1);

    if((liste_elem_ajouter(liste, elem_cheval)) != 0){
      fprintf(stderr, "Probleme ajout cheval dans liste !\n");
      exit(-1);
    }

    semop(semid_liste, &op_V,1);

    if(!liste_elem_rechercher( &id_liste_cheval, liste, elem_cheval)){
      fprintf(stderr, "Cheval introuvable dans liste !\n");
      exit(-1);
    }   

/*==================================*/
/*      Fin_Phase_Créa_&_Init       */
/*==================================*/

  while( ! fini ){
      /* Attente entre 2 coup de de */
      commun_attendre_tour() ;
      /*
       * Verif si pas decanille
       */
       semop(semid_liste, &op_P,1);

      if(elem_decanille( elem_cheval) ){
         fini = VRAI;
         semop(semid_piste, &op_P,1);
         piste_cell_effacer(piste, id_liste_cheval);
         semop(semid_piste, &op_V,1);

        if(!liste_elem_rechercher( &id_liste_cheval, liste, elem_cheval)){
          fprintf(stderr, "Cheval introuvable dans liste !\n");
          exit(-1);
        }

        if(liste_elem_supprimer(liste, id_liste_cheval) != 0){
          fprintf(stderr, "Erreur suppression cheval !\n");
          exit(-1);
        }

        semop(semid_liste, &op_V,1);

        if(elem_sem_deverrouiller(&elem_cheval) == -1){
          fprintf(stderr, "Probleme suppression semaphore cheval !\n");
          exit(-1);
        }

        elem_sem_detruire(&elem_cheval);
        exit(0);

      }else{
        semop(semid_liste, &op_V,1);
      }

      /*
       * Avancee sur la piste
       */

          /* Coup de de */
      deplacement = commun_coup_de_de() ;

#ifdef _DEBUG_
      printf(" Lancement du De --> %d\n", deplacement );
#endif

      arrivee = depart+deplacement ;

      if( arrivee > PISTE_LONGUEUR-1 ){
        arrivee = PISTE_LONGUEUR-1 ;
        fini = VRAI ;
	    }

      if( depart != arrivee ){

        /*=====================================================================*/
        /*                         Déplacement du cheval                       */
        /*                     Verification de la case d'arrivé                */
        /*  Si elle est occupé on DECANILLE le cheval qui est sur cette case   */
        /*     Sinon le cheval peut prendre ça place sur ça case d'arrivee     */
        /*=====================================================================*/

          elem_sem_verrouiller(&elem_cheval);

          if(piste_cell_occupee(piste, arrivee)){
              elem_t cheval_cible;
              cell_t c_arrive;
              int id_cheval;

              cheval_cible.cell = c_arrive;

            if(piste_cell_lire( piste, arrivee, &c_arrive) != (int)1 ){
              fprintf( stderr, "Problème de lecture de la cellule d'arrivé !\n" );
              exit(-1); 
            }
            //elem_cell_affecter(&cheval_cible, c_arrive); //decanillage de l'adversaire

            semop(semid_liste,&op_P,1);//Verrouillage de la liste pendant un decanillage

            liste_elem_rechercher(&id_cheval, liste, cheval_cible);

            cheval_cible = liste_elem_lire(liste, id_cheval);

            printf("cheval cible: %i, case cible: %i\n", id_cheval, c_arrive.pid);

            elem_sem_verrouiller(&cheval_cible);
            if(liste_elem_decaniller(liste, id_cheval)==-1){
              fprintf( stderr, "Problème DECANILLE cheval cible !\n" );
              exit(-1);  
            }
            elem_sem_deverrouiller(&cheval_cible);

            semop(semid_liste, &op_V,1);


          }

          P(semid_piste, depart);
          P(semid_piste, arrivee);

          piste_cell_effacer(piste, depart);
          commun_attendre_fin_saut();
          elem_sem_deverrouiller(&elem_cheval);

          piste_cell_affecter(piste, arrivee, cell_cheval);

          V(semid_piste, depart);
          V(semid_piste, arrivee);
         

      #ifdef _DEBUG_
          printf("Deplacement du cheval \"%c\" de %d a %d\n",marque, depart, arrivee );
      #endif
    }
      /* Affichage de la piste  */
      piste_afficher_lig( piste );

      depart = arrivee ;
  }

  printf( "Le cheval \"%c\" A FRANCHIT LA LIGNE D ARRIVEE\n" , marque );

  /*
   * Suppression du cheval de la liste
   */

    semop(semid_piste, &op_P, 1);
    piste_cell_effacer(piste, depart);
    semop(semid_piste, &op_V, 1);

    semop(semid_liste, &op_P, 1);
      if(liste_elem_supprimer(liste, id_liste_cheval) != 0){
        fprintf(stderr, "Erreur suppression cheval !\n");
        exit(-1);
      }
    semop(semid_liste, &op_V, 1);

  exit(0);
}

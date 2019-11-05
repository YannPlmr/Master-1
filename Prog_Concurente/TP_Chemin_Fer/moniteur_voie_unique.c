#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>

#include <pthread.h>

#include <sens.h>
#include <train.h>
#include <moniteur_voie_unique.h>

/*---------- MONITEUR ----------*/

extern moniteur_voie_unique_t * moniteur_voie_unique_creer( const train_id_t nb )
{
  moniteur_voie_unique_t * moniteur = NULL ; 

  /* Creation structure moniteur */
  if( ( moniteur = malloc( sizeof(moniteur_voie_unique_t) ) ) == NULL  )
    {
      fprintf( stderr , "moniteur_voie_unique_creer: debordement memoire (%lu octets demandes)\n" , 
	       sizeof(moniteur_voie_unique_t) ) ;
      return(NULL) ; 
    }

  /* Creation de la voie */
  if( ( moniteur->voie_unique = voie_unique_creer() ) == NULL )
    return(NULL) ; 
  
  /* Initialisations du moniteur */

  /***********/
  pthread_mutex_init(&moniteur->mutex_voie_occupe, NULL);
  pthread_cond_init(&moniteur->cond_entree_est, NULL);
  pthread_cond_init(&moniteur->cond_entree_ouest, NULL);
  pthread_cond_init(&moniteur->cond_VPleine, NULL);
  pthread_cond_init(&moniteur->cond_VVide, NULL);
  moniteur->nb_train_max = nb;
  moniteur->cpt = 0;
  moniteur->sens = OUEST_EST;
  
  /***********/


  return(moniteur) ; 
}

extern int moniteur_voie_unique_detruire( moniteur_voie_unique_t ** moniteur )
{
  int noerr ; 

  /* Destructions des attribiuts du moniteur */

  /***********/
  pthread_mutex_destroy(&(*moniteur)-> mutex_voie_occupe);
  pthread_cond_destroy(&(*moniteur) -> cond_entree_est);
  pthread_cond_destroy(&(*moniteur) -> cond_entree_ouest);
  pthread_cond_destroy(&(*moniteur) -> cond_VPleine);
  pthread_cond_destroy(&(*moniteur) -> cond_VVide);
  /***********/

  /* Destruction de la voie */
  if( ( noerr = voie_unique_detruire( &((*moniteur)->voie_unique) ) ) )
    return(noerr) ;

  /* Destruction de la strcuture du moniteur */
  free( (*moniteur) );

  (*moniteur) = NULL ; 

  return(0) ; 
}

extern void moniteur_voie_unique_entree_ouest( moniteur_voie_unique_t * moniteur ) 
{
  /***********/
  
  pthread_mutex_lock(&(moniteur->mutex_voie_occupe));
  
  if(moniteur->cpt==0 && moniteur->sens == EST_OUEST){
    moniteur->sens = OUEST_EST;
  }
  else if(moniteur->sens == EST_OUEST){
    pthread_cond_wait(&(moniteur->cond_entree_ouest), &(moniteur->mutex_voie_occupe));
    moniteur->sens = OUEST_EST;
  }

  if(moniteur->cpt == moniteur->nb_train_max){
    pthread_cond_wait(&(moniteur->cond_VPleine), &(moniteur->mutex_voie_occupe));
  }

  moniteur->cpt ++;

  if(moniteur->cpt > 0 && moniteur->cpt <= moniteur->nb_train_max){
    pthread_cond_signal(&(moniteur->cond_VVide));
    pthread_cond_signal(&(moniteur->cond_entree_ouest));
  }

  pthread_mutex_unlock(&(moniteur->mutex_voie_occupe));

  /***********/
}

extern void moniteur_voie_unique_sortie_est( moniteur_voie_unique_t * moniteur ) 
{
  /***********/
  pthread_mutex_lock(&(moniteur->mutex_voie_occupe));

  if(moniteur->cpt == 0){
    pthread_cond_signal(&(moniteur->cond_entree_ouest));
    pthread_cond_wait(&(moniteur->cond_VVide), &(moniteur->mutex_voie_occupe));
  }

  moniteur->cpt--;

  if(moniteur->cpt == (moniteur->nb_train_max)+1)
    pthread_cond_signal(&(moniteur->cond_VPleine));

  if(moniteur->cpt == 0){
    pthread_cond_signal(&(moniteur->cond_entree_est));
    moniteur->sens = EST_OUEST;
  }

  pthread_mutex_unlock(&moniteur->mutex_voie_occupe);

  /***********/
}

extern void moniteur_voie_unique_entree_est( moniteur_voie_unique_t * moniteur ) 
{
  /***********/
  
  pthread_mutex_lock(&(moniteur->mutex_voie_occupe));
  
  if(moniteur->cpt==0 && moniteur->sens == OUEST_EST){
     moniteur->sens = EST_OUEST;
  }
  else if(moniteur->sens == OUEST_EST){
    pthread_cond_wait(&(moniteur->cond_entree_est), &(moniteur->mutex_voie_occupe));
    moniteur->sens = EST_OUEST;
  }

  if(moniteur->cpt == moniteur->nb_train_max){
    pthread_cond_wait(&(moniteur->cond_VPleine), &(moniteur->mutex_voie_occupe));
  }

  moniteur->cpt ++;

  if(moniteur->cpt > 0 && moniteur->cpt <= moniteur->nb_train_max){
    pthread_cond_signal(&(moniteur->cond_VVide));
    pthread_cond_signal(&(moniteur->cond_entree_est));
  }

  pthread_mutex_unlock(&(moniteur->mutex_voie_occupe));

  /***********/
}

extern void moniteur_voie_unique_sortie_ouest( moniteur_voie_unique_t * moniteur ) 
{
  /***********/
  pthread_mutex_lock(&(moniteur->mutex_voie_occupe));

  if(moniteur->cpt == 0){
    pthread_cond_signal(&(moniteur->cond_entree_est));
    pthread_cond_wait(&(moniteur->cond_VVide), &(moniteur->mutex_voie_occupe));
  }

  moniteur->cpt--;

  if(moniteur->cpt == (moniteur->nb_train_max)+1)
    pthread_cond_signal(&(moniteur->cond_VPleine));

  if(moniteur->cpt == 0){
    pthread_cond_signal(&(moniteur->cond_entree_ouest));
    moniteur->sens = OUEST_EST;
  }

  pthread_mutex_unlock(&moniteur->mutex_voie_occupe);
  /***********/
}

/*
 * Fonctions set/get 
 */

extern 
voie_unique_t * moniteur_voie_unique_get( moniteur_voie_unique_t * const moniteur )
{
  return( moniteur->voie_unique ) ; 
}


extern 
train_id_t moniteur_max_trains_get( moniteur_voie_unique_t * const moniteur )
{
  /***********/
  return( moniteur->nb_train_max ) ; /* valeur arbitraire ici */
  /***********/
  
}

/*
 * Fonction de deplacement d'un train 
 */

extern
int moniteur_voie_unique_extraire( moniteur_voie_unique_t * moniteur , train_t * train , zone_t zone  ) 
{
  return( voie_unique_extraire( moniteur->voie_unique, 
				(*train), 
				zone , 
				train_sens_get(train) ) ) ; 
}

extern
int moniteur_voie_unique_inserer( moniteur_voie_unique_t * moniteur , train_t * train , zone_t zone ) 
{ 
  return( voie_unique_inserer( moniteur->voie_unique, 
			       (*train), 
			       zone, 
			       train_sens_get(train) ) ) ;
}

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
  moniteur->nb_train_max = 0;
  moniteur->nb_train_est = 0;
  moniteur->nb_train_ouest = 0;
  
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
  pthread_mutex_lock(&moniteur->mutex_voie_occupe);
  moniteur->nb_train_est++;
  if(moniteur->nb_train_est > 0){
    pthread_cond_wait(&moniteur->cond_entree_ouest, &moniteur->mutex_voie_occupe);
  }
  if(moniteur->nb_train_max < moniteur->nb_train_est){
    pthread_cond_wait(&moniteur->cond_entree_ouest, &moniteur->mutex_voie_occupe);
  }
  
  pthread_mutex_unlock(&moniteur->mutex_voie_occupe);
  printf("\nNombre de train entree est: %i", moniteur->nb_train_est);
  /***********/
}

extern void moniteur_voie_unique_sortie_est( moniteur_voie_unique_t * moniteur ) 
{
  /***********/
  pthread_mutex_lock(&moniteur->mutex_voie_occupe);
  moniteur->nb_train_ouest--;
  if(moniteur->nb_train_ouest == 0)
    pthread_cond_signal(&moniteur->nb_train_est);
  pthread_mutex_unlock(&moniteur->mutex_voie_occupe);
  printf("\nNombre de train sortie est: %i", moniteur->nb_train_est);
  /***********/
}

extern void moniteur_voie_unique_entree_est( moniteur_voie_unique_t * moniteur ) 
{
  /***********/
  pthread_mutex_lock(&moniteur->mutex_voie_occupe);
  moniteur->nb_train_ouest++;
  if(moniteur->nb_train_ouest > 0){
    pthread_cond_wait(&moniteur->cond_entree_est, &moniteur->mutex_voie_occupe);
  }
  if(moniteur->nb_train_max < moniteur->nb_train_ouest){
    pthread_cond_wait(&moniteur->cond_entree_est, &moniteur->mutex_voie_occupe);
  }
  
  pthread_mutex_unlock(&moniteur->mutex_voie_occupe);
  printf("\nNombre de train entree ouest: %i", moniteur->nb_train_ouest);
  /***********/
}

extern void moniteur_voie_unique_sortie_ouest( moniteur_voie_unique_t * moniteur ) 
{
  /***********/
  pthread_mutex_lock(&moniteur->mutex_voie_occupe);
    moniteur->nb_train_est--;
    if(moniteur->nb_train_est == 0)
      pthread_cond_signal(&moniteur->nb_train_ouest);
  pthread_mutex_unlock(&moniteur->mutex_voie_occupe);
  printf("\nNombre de train sortie ouest: %i", moniteur->nb_train_ouest);
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
  /* A FAIRE */
  /***********/
  return( 1 ) ; /* valeur arbitraire ici */
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

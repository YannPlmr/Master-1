#include <stdio.h>
#include <stdlib.h>
#include <sys/sem.h>

#define NB_SEM 5

int main(){
	int semid;
	int val = 5;
	unsigned short tab[NB_SEM] = {2,4,6,8,10};

	struct semid_ds buf;
	int i;

	/*Création de l'ensemble de NB_SEM semaphores avec une clé privée*/
	if((semid = semget(IPC_PRIVATE, 10,IPC_CREAT | 0666)) == -1){
		perror("Problème création semaphore !");
		exit(-1);
	}

	/*Exemple d'utilisation avec valeur: semaphore 2 <- 5 */

	if(semctl(semid,2,SETVAL, val) == -1){
		perror("Problème semctl SETVAL !");
		exit(-1);
	}

	val = 0;
	val = semctl(semid,2,GETVAL);
	printf("Semaphore numéro 2 de l'ensemble %d -> %d\n",semid, val);

	/*Exemple d'utilisation avec tableau. Les NB_SEM semaphores sont initialisés avec les valeur du tableau*/

	/*if(semctl(semid,NB_SEM,SETALL, &tab) == -1){
		perror("Problème semctl SETALL !");
		exit(-1);
	}

	for(i=0;i<NB_SEM;i++) tab[i]=0;
	if(semctl(semid,NB_SEM,GETALL, &tab) == -1){
		perror("Problème semctl GETALL !");
		exit(-1);
	}

	for(i=0;i<NB_SEM;i++){
		printf("Semaphore numéro %d-> %d\n",i, tab[i]);
	}*/

	/*Exemple utilisation avec buffer. récupération des caractéristiques des semaphores dans le buf*/

	if(semctl(semid,0,IPC_STAT, &buf) == -1){
		perror("Problème semctl IPC_STAT !");
		exit(-1);
	}
	printf("Ensemble %d:\n",semid);
	printf("\t- Nombre de semaphores = %ld\n",buf.sem_nsems);
	printf("\t- UID = %d\n",buf.sem_perm.uid);
	printf("\t- GID = %d\n",buf.sem_perm.gid);

	/*Exemple utilisation sans arguments. Destrucion semaphore*/

	semctl(semid,0, IPC_RMID, 0);
	exit(0);
}

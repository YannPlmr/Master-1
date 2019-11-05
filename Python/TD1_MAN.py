#!/bin/env python3
#-*- coding: utf-8 -*-

def affiche_ligne_fichier(nomfichier, mode, n):
    fichier = open(nomfichier,mode, encoding="utf-8")
    for line in range(n):
        # Traitement de la ligne
        print("ligne",line, ":", fichier.readline().strip())
    fichier.close()

def affiche_ligne_choisi(nomfichier, mode, n):
    fichier = open(nomfichier,mode, encoding="utf-8")
    for line_counter, line_value in enumerate(fichier):
        if line_counter == n:
            # Traitement de la ligne
            print("ligne",line_counter, ":", line_value)
    fichier.close()

def stockerLigne(line, dicPron):
        fichier = open(dicPron,"a", encoding="utf-8")
        fichier.write(line)
        fichier.close()

        fichier = open(dicPron,"r", encoding="utf-8")
        for n in fichier:
            # Traitement de la ligne
            print( fichier.readline().strip())
        fichier.close()

def AfficherPron(mot, dicPron):
        fichier = open(dicPron,"r", encoding="utf-8")
        for line in fichier.readlines():
            if mot in line:
                print(line)
        fichier.close()

def AfficherMots(p, dicPron):
    fichier = open(dicPron,"r", encoding="utf-8")
    dic=[]
    for line in fichier.readlines():
        if p in line:
            dic.append(line)

    for index, value in enumerate(dic):
            for a in value:
                if a != ';':
                    print(a)


    fichier.close()


#affiche_ligne_fichier("synpaflex-pronunciation-dictionary.txt", "r", 10)
#affiche_ligne_choisi("synpaflex-pronunciation-dictionary.txt", "r", 6)
#stockerLigne("zoo; z o; z o", "synpaflex-pronunciation-dictionary.txt")
#AfficherPron("coulée", "synpaflex-pronunciation-dictionary.txt")
AfficherMots("k u l e", "synpaflex-pronunciation-dictionary.txt")

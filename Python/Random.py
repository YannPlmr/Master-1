#!/bin/env python3
#-*- coding: utf-8 -*-

import numpy as np
import numpy.random as nprd
import matplotlib.pyplot as plt

N = 1000
MIN = 0
MAX = 10

MU = 4
SIG = 1.5

LAMBD = 4

UP = 4

x=np.linspace(MIN,MAX,N)

def uni():
    return nprd.uniform(MIN,MAX,N)

def norm():
    return nprd.normal(MU, SIG, N)

def tria():
    return nprd.triangular(MIN,UP,MAX, N)

def expo():
    return nprd.exponential(1/LAMBD,N)

def verifMoy(theo, loi, nom_loi):
    print(nom_loi)
    print(theo)
    print(np.mean(loi))


y_uni = uni()
y_uni.sort()
uni_moy_theo = (MAX+MIN)/2
verifMoy(uni_moy_theo, np.mean(y_uni), "\n===uniforme===")

y_norm = norm()
y_norm.sort()
norm_moy_theo = MU
verifMoy(norm_moy_theo, np.mean(y_norm), "\n===normale===")

y_tria = tria()
y_tria.sort()
tria_moy_theo = (MIN+UP+MAX)/3
verifMoy(tria_moy_theo, np.mean(y_tria), "\n===triangulaire===")

y_expo =  expo()
y_expo.sort()
expo_moy_theo = 1/LAMBD
verifMoy(expo_moy_theo, np.mean(y_expo), "\n===exponentielle===")

plt.subplot(2,2,1)
plt.title("loi uniforme")
plt.hist(y_uni, 20)
plt.plot(x,y_uni)

plt.xlim(0, 10)
#plt.ylim(0, 10)
plt.xlabel('N')
#plt.ylabel('amplitude (UA)')

plt.subplot(2,2,2)
plt.title("loi normal")
plt.hist(y_norm, 20)
plt.plot(x,y_norm)

plt.xlim(0, 10)
#plt.ylim(0, 10)
plt.xlabel('N')
#plt.ylabel('amplitude (UA)')

plt.subplot(2,2,3)
plt.title("loi triangulaire")
plt.hist(y_tria, 20)
plt.plot(x,y_tria)

plt.xlim(0, 10)
#plt.ylim(0, 10)
plt.xlabel('N')
#plt.ylabel('amplitude (UA)')

plt.subplot(2,2,4)
plt.title("loi exponentielle")
plt.hist(y_expo, 20)
plt.plot(x,y_expo)

plt.xlim(0, 10)
#plt.ylim(0, 10)
plt.xlabel('N')
#plt.ylabel('amplitude (UA)')
plt.show()

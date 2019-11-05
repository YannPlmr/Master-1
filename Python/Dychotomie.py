#!/bin/env python3
#-*- coding: utf-8 -*-

import numpy as np
import numpy.random as nprd
import matplotlib.pyplot as plt

choix = nprd.randint(0, 100)

def f(x):
    return np.log(x)+x**2

def dichotomie():
    a=0.5
    b=1
    cpt=0
    dicho = b


    while (abs(f(dicho)) >= 10**-3):
        cpt+=1
        dicho = (int)((a+b)/2)
        p=f(dicho)*f(a)
        if p < 0:
            b = dicho
            print("b =", dicho)
        elif p > 0:
            a = dicho
            print("a =", dicho)
        else:
            break
    print('Le nombre est ', dicho)
    print('cpt = ', cpt)

dichotomie()

#!/bin/env python3
#-*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt

def f(x):
    return 1/(np.sqrt(1+x**2))

def int_carre(val,n):
    return val.sum()*n

def int_trapz(val, n):
    sum = 0
    for x in range(len(val)-1):
        a = ech[x]
        b = ech[x+1]
        sum += (b-a)*(f(a)+f(b))/2
    return sum

def int_simpson(val, n):
    sum = 0
    for x in range(len(val)-1):
        a = ech[x]
        b = ech[x+1]
        sum += ((b-a)/6)*(f(a)+4*f((a+b)/2)+f(b))
    return sum

n=100
#ech=np.linspace(0,1,n)
ech=np.linspace(0,1,n, endpoint=False)

plt.plot(ech,f(ech))
plt.scatter(ech,f(ech))

print("\t\t====RESULTATS====")
print("intégrale carré = ", int_carre(f(ech),1/n))
print("\t\t========")
print("intégrale trapz(np.trapz) = ", np.trapz(f(ech),ech))
print("\t\t========")
print("intégrale trapz = ", int_trapz(ech ,1/n))
print("\t\t========")
print("intégrale simpson = ", int_simpson(ech ,1/n))
print("\t\t========")

plt.show()

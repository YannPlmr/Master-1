#!/bin/env python3
#-*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile

freq = 8000
tps = 1
t=np.linspace(0,1,freq*tps)

a=0
f0=10

carre = np.asarray([1.,0.,1/3,0.,1/5,0.,1/7,0.,1/9])
tri = np.asarray([1.,0.,-1/9,0.,1/25,0.,-1/49,0.,1/81])
scie = np.asarray([1.,-1/2,1/3,-1/4,1/5,-1/6,1/7,-1/8,1/9])

s=np.empty((t.shape))
s.shape

for k,bk in enumerate(carre):
    x = bk * np.sin(2*np.pi*(k+1)*f0*t)
    s=np.vstack((s,x))


plt.plot(t,np.sum(s, axis = 0))
#plt.xlim(.05, .150)
plt.xlabel('temps (s)')
plt.ylabel('amplitude (UA)')
plt.show()

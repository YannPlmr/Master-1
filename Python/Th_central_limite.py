#!/bin/env python3
#-*- coding: utf-8 -*-

import numpy as np
import numpy.random as nprd
import matplotlib.pyplot as plt

def norm(mu, sig, N):
    return nprd.normal(mu, sig, N)

y_norm = norm(0,1,10000)
p_bino = nprd.binomial(100, 0.5, 10000)

t=np.linspace(0,10,10+1)

const, bins, _ = plt.hist(y_norm, 100, normed = True, alpha=0.5, label="binomial")
plt.hist(p_bino, bins, normed= True, alpha=0.5, label="binomial")
plt.plot(bins, 1/np.sqrt(2*np.pi)*np.exp((-(bins)**2)/2))
#plt.xlim(.05, .150)
plt.xlabel('temps (s)')
plt.ylabel('amplitude (UA)')
plt.show()

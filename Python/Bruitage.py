#!/bin/env python3
#-*- coding: utf-8 -*-

import numpy as np
import numpy.random as nprd
import matplotlib.pyplot as plt
from scipy.io import wavfile

def uni(min, max, N):
    return nprd.uniform(min,max,N)

def norm(mu, sig, N):
    return nprd.normal(mu, sig, N)

fs, stereo = wavfile.read('td3.wav')
print("Fréquence d'échantillonage du fichier audio est ", fs, "Hz\n")

mono = np.array(stereo[:,0], dtype = 'float64')/np.max(stereo)

tps = len(mono)/fs
t=np.linspace(0,tps,fs*tps)

bruit_uni = uni(-0.05,0.05, len(mono))
newmono_uni = mono + bruit_uni

bruit_norm = norm(0,0.01, len(mono))
newmono_norm = mono + bruit_norm

plt.subplot(2,3,1)
plt.title("mono")
plt.plot(t,mono)

plt.subplot(2,3,4)
plt.title("mono[fs:fs+1000]")
plt.plot(t[fs:fs+1000],mono[fs:fs+1000])


plt.subplot(2,3,2)
plt.title("mono+bruit_uni")
plt.plot(t,newmono_uni)
plt.subplot(2,3,5)
plt.title("mono[fs:fs+1000]+bruit_uni[fs:fs+1000]")
plt.plot(t[fs:fs+1000],newmono_uni[fs:fs+1000])


plt.subplot(2,3,3)
plt.title("mono+bruit_norm")
plt.plot(t,newmono_norm)
plt.subplot(2,3,6)
plt.title("mono[fs:fs+1000]+bruit_norm[fs:fs+1000]")
plt.plot(t[fs:fs+1000],newmono_norm[fs:fs+1000])

plt.show()

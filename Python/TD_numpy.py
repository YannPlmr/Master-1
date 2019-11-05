#!/bin/env python3
#-*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile

freq = 100000000

t=np.linspace(0,1,freq+1)
#print(np.where(t==50))

a=1.5
f0=440
O=0

x = a*np.sin(2*np.pi*f0*t+O)

plt.plot(t,x)
plt.xlim(.05, .150)
plt.xlabel('temps (s)')
plt.ylabel('amplitude (UA)')
plt.show()

wavfile.write('file.wav', 1000,x)

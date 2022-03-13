
from rtiCUDA import rcarray
from rtiCUDA import messageSender
import numpy as np
import time
import math

k=3

if __name__=='__main__':
    messageSender.connect("andrej")
    start = time.perf_counter()
    ars1 = []
    ars2 = []
    for i in range(3):
        ar1 = rcarray.makeRcArray("int",[5],1)
        ars1.append(ar1)
    for i in range(2):
        ar2 = rcarray.makeRcArray("int",[5],2)
        ars1.append(ar2)
    ar3 = rcarray.makeMatrix("int",ars1,5)
    print(ar3)
    rcarray.transpose(ar3)
    print(ar3)
    ar3[1,0]=20
    print(ar3)
    print(ar3[1,:])
    messageSender.disconnect()
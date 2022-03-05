
from rtiCUDA import rcarray
from rtiCUDA import messageSender
import numpy as np
import time
import math

k=500

if __name__=='__main__':
    messageSender.connect("andrej")
    start = time.perf_counter()
    ars1 = []
    ars2 = []
    for i in range(k):
        ar1 = rcarray.makeRcArray("int",[k],1)
        ars1.append(ar1)
        ar2 = rcarray.makeRcArray("int",[k],1)
        ars2.append(ar2)
    ar3 = rcarray.makeMatrix("int",ars1,k)
    ar6 = rcarray.makeMatrix("int",ars2,k)
    #print(ar3)
    #print(ar6)
    start = time.perf_counter()
    ar7 = rcarray.dot(ar3,ar6)
    p = rcarray.sum(ar7)
    end = time.perf_counter()
    print(end-start)

    np1 = np.ones((k,k))
    np2 = np.ones((k,k))
    #print(ar7)
    start = time.perf_counter()

    np3 = np.matmul(np1, np2)
    s=np.sum(np3)
    end = time.perf_counter()
    print(end-start)

    messageSender.disconnect()
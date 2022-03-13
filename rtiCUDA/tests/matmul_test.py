
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
        ar1 = rcarray.makeRcArray("double",[2],1)
        ars1.append(ar1)
    for i in range(2):
        ar2 = rcarray.makeRcArray("double",[3],2)
        ars2.append(ar2)
    ar3 = rcarray.makeMatrix("double",ars1,3)
    ar6 = rcarray.makeMatrix("double",ars2,2)
    print(ar3)
    print(ar6)
    start = time.perf_counter()
    ar7 = rcarray.dot(ar3,ar6)
    p = rcarray.sum(ar7)
    end = time.perf_counter()
    print(ar7)
    print(p)
    print(end-start)

    messageSender.disconnect()
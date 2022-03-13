from rtiCUDA import rcarray
from rtiCUDA import messageSender
import numpy as np
import time
import math

if __name__=='__main__':
    messageSender.connect("andrej")
    ar1 = rcarray.makeRcArray("int",[3],2)
    print(ar1)    
    ar2 = ar1/3
    print(ar2)
    arrs = []
    for i in range(5):
        arrs.append(rcarray.makeRcArray("int",[4],i))
    mat = rcarray.makeMatrix("int",arrs,5)
    print(mat)
    k = rcarray.submatrix(mat,2,1,2,2)
    print(k)
    #print(np.sum(np3))
    #start = time.perf_counter()
    #for i in range(1):
    #    ar2=ar2*ar1
    #end=time.perf_counter()
    #print(f"cuda took {end - start:0.9f} seconds")
    #start = time.perf_counter()
    #for i in range(1):
    #    np2=np2*np1
    #end=time.perf_counter()
    #print(np1)
    #print(f"numpy took {end - start:0.9f} seconds")
    messageSender.disconnect()

from rtiCUDA import rcarray
from rtiCUDA import messageSender
import numpy as np
import time
import math

if __name__=='__main__':
    messageSender.connect("andrej")
    for l in range(5,1000,10):
        ar1 = rcarray.makeRcArray("double",[l*100000],2.5)
        ar2 = rcarray.makeRcArray("double",[l*100000],2.5)
        #print(ar2)
        start = time.perf_counter()
        for i in range(10):
            ar3=ar1*ar2
        end=time.perf_counter() 
        t1 = end - start

        
        #print(ar3)
        np1 = np.ones(l*100000)*2.5
        np2 = np.ones(l*100000)*2.5
        start = time.perf_counter()
        for i in range(10):
            np3=np1*np2
        end=time.perf_counter()
        t2 = end - start
        print(l*100000,t1,t2)
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

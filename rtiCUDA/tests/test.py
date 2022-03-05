from rtiCUDA import rcarray
from rtiCUDA import messageSender
import numpy as np
import time
import math

if __name__=='__main__':
    messageSender.connect("andrej")
    for l in range(5,1000,10):
        ar1 = rcarray.makeRcArray("int",[l*2],2)
        ar2 = rcarray.makeRcArray("int",[l*2],2)
        #print(ar2)
        start = time.perf_counter()
        for i in range(l*2*l*2):
            ar3=ar1*ar2
        end=time.perf_counter() 
        t1 = end - start

        
        #print(ar3)
        np1 = np.ones(l*2)*2
        np2 = np.ones(l*2)*2
        start = time.perf_counter()
        for i in range(l*2*l*2):
            np3=np1*np2
        end=time.perf_counter()
        t2 = end - start
        print(l*2,t1,t2)
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

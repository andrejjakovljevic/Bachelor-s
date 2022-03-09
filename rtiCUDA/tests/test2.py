from sunau import AUDIO_FILE_ENCODING_LINEAR_32
from rtiCUDA import rcarray
from rtiCUDA import messageSender
import numpy as np
import time
import math

if __name__=='__main__':
    messageSender.connect("andrej")
    for l in range(5,1000,10):
        ar1 = rcarray.makeRcArray("int",[l*100000],2)
        ar2 = rcarray.makeRcArray("int",[l*100000],2)
        #print(ar2)
        start = time.perf_counter()
        for i in range(2):
            ar3=ar1*ar2
        end=time.perf_counter() 
        t1 = end - start

        
        #print(ar3)
        np1 = np.ones(l*100000)*2
        np2 = np.ones(l*100000)*2
        start = time.perf_counter()
        for i in range(2):
            np3=np1*np2
        end=time.perf_counter()
        t2 = end - start
        print(l*100000,t1,t2)
    messageSender.disconnect()
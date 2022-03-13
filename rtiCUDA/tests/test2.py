import cProfile
from sunau import AUDIO_FILE_ENCODING_LINEAR_32
from rtiCUDA import rcarray
from rtiCUDA import messageSender
import numpy as np
import time
import math

def to_test(ar1, ar2):
    for i in range(100):
        ar3=ar1*ar2

if __name__=='__main__':
    messageSender.connect("andrej")
    for l in range(5,1000,10):
        ar1 = rcarray.makeRcArray("int",[l*100000],2)
        ar2 = rcarray.makeRcArray("int",[l*100000],2)
        #print(ar2)
        start = time.perf_counter()
        messageSender.start_tracing()
        cProfile.run('to_test(ar1,ar2)','stats/stats'+str(l)+'.txt')
        k = messageSender.stop_tracing()
        end=time.perf_counter()
        t1 = end - start

        
        #print(ar3)
        np1 = np.ones(l*100000)*2
        np2 = np.ones(l*100000)*2
        start = time.perf_counter()
        for i in range(100):
            np3=np1*np2
        end=time.perf_counter()
        t2 = end - start
        print(l*100000,k,t1,t2)
    messageSender.disconnect()
import cupy as cp
from cupy import prof
import time

def to_test(ar1, ar2):
    for i in range(100):
        ar3=ar1*ar2

for l in range(5,1000,10):
    np1 = cp.ones(l*100000)*2
    np2 = cp.ones(l*100000)*2
    cp.cuda.runtime.deviceSynchronize()
    start = time.perf_counter()
    to_test(np1,np2)
    cp.cuda.runtime.deviceSynchronize()
    end=time.perf_counter()
    t2 = end - start
    print(l*100000,t2)
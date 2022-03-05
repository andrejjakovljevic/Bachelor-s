
from rtiCUDA import rcarray
from rtiCUDA import messageSender
import numpy as np
import time
import math

if __name__=='__main__':
    messageSender.connect("andrej")
    ar1 = rcarray.makeRcArray("double",[3],2)
    ar2 = rcarray.makeRcArray("double",[3],2)
    #print(ar2)
    for i in range(10):
        ar2=ar1+ar2 
    print(ar2)

    messageSender.disconnect()
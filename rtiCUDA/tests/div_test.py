
from rtiCUDA import rcarray
from rtiCUDA import messageSender
import numpy as np
import time
import math

k=3

if __name__=='__main__':
    messageSender.connect("andrej")
    ar1 = rcarray.makeRcArray("double",[k],6.33)
    ar2 = rcarray.makeRcArray("int",[k],4)
    ar3 = ar1/ar2
    print (ar3)
    messageSender.disconnect()
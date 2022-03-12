from sunau import AUDIO_FILE_ENCODING_LINEAR_32
from rtiCUDA import rcarray
from rtiCUDA import messageSender
import numpy as np
import time
import math

if __name__=='__main__':
    messageSender.connect("andrej")
    ar1 = rcarray.makeRcArray("int",[4],2)
    print(ar1)
    b = ar1[1:3]
    ar2 = rcarray.makeRcArray("int",[4],1)
    ar2[0:2]=b
    print(b)
    print(ar2)
    print(ar2[2:])
    help = rcarray.makeRcArray("int",[2],10)
    ar1[1:3]=help
    print(ar1)
    messageSender.disconnect()
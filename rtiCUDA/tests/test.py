from rtiCUDA import rcarray
from rtiCUDA import messageSender


if __name__=='__main__':
    messageSender.connect("andrej")
    ar1 = rcarray.makeRcArray("int",[3],2)
    ar2 = rcarray.makeRcArray("double",[3],3.5)
    print(ar2)
    ar3 = ar1+ar2
    print(ar3)
    ar3[0]=1
    print(ar3)
    print(ar3[1])
    print(ar3[0])
    messageSender.disconnect()

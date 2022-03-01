from rtiCUDA import rcarray
from rtiCUDA import messageSender


if __name__=='__main__':
    messageSender.connect("andrej")
    ar1 = rcarray.makeRcArray("int",[1000000],1)
    print(rcarray.sum(ar1))
    messageSender.disconnect()

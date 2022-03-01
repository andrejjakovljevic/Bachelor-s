from rtiCUDA import rcarray


if __name__=='__main__':
    ar1 = rcarray.makeRcArray("int",[3],2)
    ar2 = rcarray.makeRcArray("int",[3],3)
    ar3 = ar1+ar2
    print(ar3)

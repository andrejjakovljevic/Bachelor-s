import math
import numpy as np
from scipy.sparse import csr_matrix
import time
import sys
from rtiCUDA import rcarray
from rtiCUDA import messageSender
import cProfile

def create_blocks_scalar(A: np.ndarray):
    out = []
    for k in A:
        out.append(rcarray.makeRcArrayFromNumpy("int",k,1))
    return out

def get_matrices(filename):
    f = open(filename, "r")
    fs = []
    ss = []
    datas = []
    i=0
    shapes = -1
    for x in f:
        if (x[0]=='%'):
            continue
        if (i==0):
            spl = x.split(' ')
            shape_size = int(spl[0])
        if (x=="\n"):
            continue
        if (i>0):
            spl = x.split(' ')
            f = int(spl[0])-1
            s = int(spl[1])-1
            data = 1
            if (s>f):
                (f, s) = (s, f)
            fs.append(f)
            ss.append(s)
            datas.append(data)
        i+=1
    s_mat = csr_matrix((datas,(fs, ss)), shape=(shape_size, shape_size))
    s_mat_t = s_mat.transpose(axes = None, copy=True)
    return (s_mat,s_mat_t)

def triangle_count_cuda(A: list, At: list) -> int:
    ar1 = rcarray.makeMatrix("int",A,len(A))
    ar1t = rcarray.makeMatrix("int",At,len(At))
    helper = rcarray.dot(ar1,ar1t)
    return rcarray.sum(helper*ar1)

def triangle_count_numpy(A: list, At: list):
    np1 = np.stack(A, axis=0)
    np1t = np.stack(At, axis=0)
    helper=np.matmul(np1,np1t)
    return np.sum(helper*np1)
    

messageSender.connect("andrej")
(s_mat, s_mat_t) = get_matrices("matrices/"+sys.argv[1]+".mtx")
dense1 = s_mat.todense().tolist()
dense2 = s_mat_t.todense().tolist()
h1 = np.array(dense1,np.int64)
h2 = np.array(dense2,np.int64)
pd_out = create_blocks_scalar(h1)
pd_out_t = create_blocks_scalar(h2)
start = time.perf_counter()
messageSender.start_tracing()
cProfile.run('triangle_count_cuda(pd_out,pd_out_t)','stats/tri_count_'+sys.argv[1]+'txt')
k = messageSender.stop_tracing()
end=time.perf_counter() 
t1 = end - start
start = time.perf_counter()
sol2 = triangle_count_numpy(h1,h2)
end=time.perf_counter() 
t2 = end - start
print(sys.argv[1],len(pd_out),len(pd_out_t),k,t1,t2)
messageSender.disconnect()
#pd_out = create_blocks_scalar(np.array(dense1,np.int64))
#pd_out_t = create_blocks_scalar(np.array(dense2, np.int64))
#start = time.perf_counter()
#ak.startTracing()
#cProfile.run('to_profile(pd_out, pd_out_t)')
#ak.stopTracing()
#end = time.perf_counter()
#exec_time = end - start
#print(f"transpose_v0 took {end - start:0.9f} seconds")
#f.write(sys.argv[1]+"\n")
#f.write(f"{exec_time:0.9f}\n")
#start = time.perf_counter()
#print(ak.triangle_count(pd_out))
#end = time.perf_counter()
#print(f"transpose_v1 took {end - start:0.9f} seconds")
import wave
import numpy as np
from scipy.sparse import csr_matrix
from rtiCUDA import rcarray
from rtiCUDA import messageSender
import sys
import time
import cProfile

def create_blocks_scalar(A: np.ndarray):
    out = []
    for k in A:
        out.append(rcarray.makeRcArrayFromNumpy("int",k,1))
    out = rcarray.makeMatrix("int",out,len(A))
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

def numpty_bfs(wavefronts, vs, A):
    for i in range(len(wavefronts)):
        wavefront=wavefronts[i]
        v = vs[i]
        while True:
            v=v+wavefront
            wavefront=(wavefront@A)*np.invert(v)
            #print(v)
            k = np.count_nonzero(wavefront)
            #print(wavefront)
            if (k==0):
                break

def rtiCuda_bfs(wavefronts, vs, A):
    for i in range(len(wavefronts)):
        wavefront=wavefronts[i]
        v = vs[i]
        while True:
            v=v+wavefront
            #print(v)
            wavefront = rcarray.dot(wavefront,A)*rcarray.inverse(v)
            k=rcarray.sum(wavefront)
            #print(wavefront)
            if (k==0):
                break

if __name__=='__main__':
    messageSender.connect("andrej")
    (s_mat, s_mat_t) = get_matrices("matrices/"+sys.argv[1]+".mtx")
    dense1 = s_mat.todense().tolist()
    dense2 = s_mat_t.todense().tolist()
    h1 = np.array(dense1,np.int64)
    h2 = np.array(dense2,np.int64)
    bool_h1 = np.array(h1,dtype=bool)
    vs = []
    wavefronts = []
    vs_rc = []
    wavefronts_rc = []
    pd_out = create_blocks_scalar(h1)
    pd_out_t = create_blocks_scalar(h2)
    for i in range(len(h1)):
        wavefront = np.zeros(len(h1), dtype=bool)
        wavefront_int = np.zeros(len(h1), dtype=int)
        wavefront_int[i]=1
        wavefront[i]=True
        v_int = np.zeros(len(h1), dtype=int)
        v = np.zeros(len(h1), dtype=bool)
        wavefront_rc = []
        wavefront_rc.append(rcarray.makeRcArrayFromNumpy("int",wavefront_int,1))
        v_rc = []
        v_rc.append(rcarray.makeRcArrayFromNumpy("int",v_int,1))
        wavefront_rc = rcarray.makeMatrix("int",wavefront_rc,1)
        v_rc = rcarray.makeMatrix("int",v_rc,1)
        vs.append(v)
        wavefronts.append(wavefront)
        vs_rc.append(v_rc)
        wavefronts_rc.append(wavefront_rc)
    start = time.perf_counter()
    messageSender.start_tracing()
    cProfile.run('rtiCuda_bfs(wavefronts_rc, vs_rc, pd_out)','stats/bfs_trace_'+sys.argv[1]+'txt')
    k = messageSender.stop_tracing()
    end=time.perf_counter() 
    p1 = end-start

    start = time.perf_counter()
    messageSender.start_tracing()
    numpty_bfs(wavefronts, vs, bool_h1)
    k = messageSender.stop_tracing()
    end=time.perf_counter() 
    p2 = end-start
    print(sys.argv[1],len(h1),k,p1,p2)
    messageSender.disconnect()
    
import math
from turtle import st
import cupy as np
from rtiCUDA import rcarray
from rtiCUDA import messageSender
import time
from sklearn import datasets
import cProfile

def takesub(arr : rcarray, x):
    d=dict()
    d["operation"]="rangeget"
    d["start"]=x*arr.dims[1]
    d["stop"]=arr.dims[0]*arr.dims[1]
    d["id"]=arr.id
    d["type"]=arr.type
    resp = messageSender.sendMessage(d)
    return rcarray.rcarray(resp["id"],arr.type,[arr.dims[0]-x,arr.dims[1]],2)

def take_row_as_sub(arr : rcarray, x, poc, kraj):
    d=dict()
    d["operation"]="rangeget"
    d["start"]=x*arr.dims[1]+poc
    d["stop"]=x*arr.dims[1]+kraj
    d["id"]=arr.id
    d["type"]=arr.type
    resp = messageSender.sendMessage(d)
    return rcarray.rcarray(resp["id"],arr.type,[kraj-poc,1],2)

def take_row_as_sub2(arr : rcarray, x, poc, kraj):
    d=dict()
    d["operation"]="rangeget"
    d["start"]=x*arr.dims[1]+poc
    d["stop"]=x*arr.dims[1]+kraj
    d["id"]=arr.id
    d["type"]=arr.type
    resp = messageSender.sendMessage(d)
    return rcarray.rcarray(resp["id"],arr.type,[1,kraj-poc],2)

def cholesky(A,L,n):
    for k in range(n):
        help = A[k, k] - np.sum(L[k, :] ** 2)
        if (help<=0):
            help=1
        L[k, k] = np.sqrt(help)
        L[(k+1):, k] = (A[(k+1):, k] - L[(k+1):, :] @ L[:, k]) / L[k, k]
        #print(L[(k+1):, k])
    return L

def cholesky_rcarray(A,L,n):
    for k in range(n):
        help = A[k,k] - rcarray.sum(L[k, :] * L[k, :])
        if (help<=0): 
            help=1
        s = np.sqrt(help)
        L[k, k] = s 
        if (k==n-1):
            break
        helper = takesub(L,k+1)
        rcarray.transpose(L)
        helper2 = take_row_as_sub(L,k,0,L.dims[1])
        rcarray.transpose(L)
        mno = rcarray.dot(helper,helper2)
        rcarray.transpose(A)
        p = take_row_as_sub(A,k,(k+1),A.dims[1])
        rcarray.transpose(A)
        rcarray.flatten(p)
        rcarray.flatten(mno)
        lov = rcarray.makeRcArray("double",[p.dims[0]],L[k,k])
        rcarray.transpose(L)
        L[k,(k+1):]=((p-mno))/lov
        rcarray.transpose(L)
    return L

n=800

def doolittle_cuda(A,n,U,L):
    for k in range(n):
        if (k==0):
            U[k,k:]=A[k,k:]
        else:
            podskup = rcarray.submatrix(U,k,0,n-k,k)
            levi_mno = take_row_as_sub2(L,k,0,k)
            mno = rcarray.dot(levi_mno,podskup)
            odu_levi = take_row_as_sub2(A,k,k,n)
            pomoc = odu_levi-mno
            rcarray.flatten(pomoc)
            U[k,k:]=pomoc
        if (k==n-1):
            break
        rcarray.transpose(U)
        mno_desno = take_row_as_sub(U,k,0,n)
        rcarray.transpose(U)
        mno_levo = takesub(L,k+1)
        mno = rcarray.dot(mno_levo,mno_desno)
        rcarray.transpose(A)
        p = take_row_as_sub(A,k,(k+1),A.dims[1])
        rcarray.transpose(A)
        rcarray.flatten(p)
        rcarray.flatten(mno)
        rcarray.transpose(L)
        L[k,(k+1):]=((p-mno))/U[k,k]
        rcarray.transpose(L)
    return L,U

def doolittle(A,n,U,L):
    
    #n = A.shape[0]
    
    for k in range(n):
        U[k, k:] = A[k, k:] - L[k,:k] @ U[:k,k:]
        L[(k+1):,k] = (A[(k+1):,k] - L[(k+1):,:] @ U[:,k]) / U[k, k]
    
    return L, U

if __name__=='__main__':
    messageSender.connect("andrej")
    for n in range(5,500,20):
        A = np.array(datasets.make_spd_matrix(n, random_state=None))
        #L, U = doolittle(A)
        #print(L@U)
        #print(L)
        #print(A)
        #print(np.linalg.cholesky(A))
        U = np.zeros((n, n), dtype=np.double)
        L = np.eye(n, dtype=np.double)
        start = time.perf_counter()
        doolittle(A,n,U,L)
        end = time.perf_counter()
        #print(L)
        #print(U)
        #print(sol)
        t1 = end-start
        A_rc = []
        for i in range(n):
            A_rc.append(rcarray.makeRcArrayFromNumpy("double",A[i],1))
        A_rc = rcarray.makeMatrix("double",A_rc,n)
        L = []
        U = []
        for i in range(n):
            ar1 = rcarray.makeRcArray("double",[n],0)
            ar2 = rcarray.makeRcArray("double",[n],0)
            L.append(ar1)
            U.append(ar2)
        L = rcarray.makeMatrix("double",L,n)
        U = rcarray.makeMatrix("double",U,n)
        for i in range(n):
            L[i,i]=1
        np.cuda.runtime.deviceSynchronize()
        start = time.perf_counter()
        doolittle_cuda(A_rc,n,U,L)
        np.cuda.runtime.deviceSynchronize()
        end = time.perf_counter()
        #print(L)
        #print(U)
        #print(p)
        t2 = end-start
        print(n,t2,t1)
    messageSender.disconnect()
    
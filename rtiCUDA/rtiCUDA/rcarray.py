from array import array
import string
from tracemalloc import stop
from rtiCUDA import messageSender
import numpy as np

class rcarray:
    
    def __init__(self, id : int, type : string, dims : list, dim : int) -> None:
        self.id = id
        self.type = type
        self.dims = dims
        self.dim = dim

    def __add__(self, o):
        d=dict()
        d["operation"]="binopvv"
        if (len(self.dims)==1 and len(o.dims)==1):
            if (self.dims[0]!=o.dims[0]):
                raise Exception("Arrays must be of same dimensions")
            t : string = "int"
            if (self.type=="double" or o.type=="double"):
                t="double"
            d["op"]="+"
            d["length"]=o.dims[0]
            d["id1"]=self.id
            d["id2"]=o.id
            d["type"]=t
            resp = messageSender.sendMessage(d)
            dims = []
            dims.append(self.dims[0])
            return rcarray(resp["id"],t,dims,1)
        if (len(self.dims)==2 and len(o.dims)==2):
            if (self.dims[1]!=o.dims[1] or self.dims[0]!=o.dims[0]):
                raise Exception("Arrays must be of same dimensions")
            t : string = "int"
            if (self.type=="double" or o.type=="double"):
                t="double"
            d["op"]="+"
            d["length"]=o.dims[0]*o.dims[1]
            d["id1"]=self.id
            d["id2"]=o.id
            d["type"]=t
            resp = messageSender.sendMessage(d)
            return rcarray(resp["id"],t,self.dims,2)
    
    def __sub__(self, o):
        d=dict()
        d["operation"]="binopvv"
        if (len(self.dims)==1 and len(o.dims)==1):
            if (self.dims[0]!=o.dims[0]):
                raise Exception("Arrays must be of same dimensions")
            t : string = "int"
            if (self.type=="double" or o.type=="double"):
                t="double"
            d["op"]="-"
            d["length"]=o.dims[0]
            d["id1"]=self.id
            d["id2"]=o.id
            d["type"]=t
            resp = messageSender.sendMessage(d)
            dims = []
            dims.append(self.dims[0])
            return rcarray(resp["id"],t,dims,1) 
        if (len(self.dims)==2 and len(o.dims)==2):
            if (self.dims[1]!=o.dims[1] or self.dims[0]!=o.dims[0]):
                raise Exception("Arrays must be of same dimensions")
            t : string = "int"
            if (self.type=="double" or o.type=="double"):
                t="double"
            d["op"]="-"
            d["length"]=o.dims[0]*o.dims[1]
            d["id1"]=self.id
            d["id2"]=o.id
            d["type"]=t
            resp = messageSender.sendMessage(d)
            return rcarray(resp["id"],t,self.dims,2)

    def __mul__(self, o):
        d=dict()
        d["operation"]="binopvv"
        if (len(self.dims)==1 and len(o.dims)==1):
            if (self.dims[0]!=o.dims[0]):
                raise Exception("Arrays must be of same dimensions")
            t : string = "int"
            if (self.type=="double" or o.type=="double"):
                t="double"
            d["op"]="*"
            d["length"]=o.dims[0]
            d["id1"]=self.id
            d["id2"]=o.id
            d["type"]=t
            resp = messageSender.sendMessage(d)
            dims = []
            dims.append(self.dims[0])
            return rcarray(resp["id"],t,dims,1)   
        if (len(self.dims)==2 and len(o.dims)==2):
            if (self.dims[1]!=o.dims[1] or self.dims[0]!=o.dims[0]):
                raise Exception("Arrays must be of same dimensions")
            t : string = "int"
            if (self.type=="double" or o.type=="double"):
                t="double"
            d["op"]="*"
            d["length"]=o.dims[0]*o.dims[1]
            d["id1"]=self.id
            d["id2"]=o.id
            d["type"]=t
            resp = messageSender.sendMessage(d)
            return rcarray(resp["id"],t,self.dims,2)      


    def __str__(self):
        d=dict()
        if (len(self.dims)==1):
            d["operation"]="print"
            d["length"]=self.dims[0]
            d["type"]=self.type
            d["id"]=self.id
            resp = messageSender.sendMessage(d)
            return resp["array"].__str__()
        if (len(self.dims)==2):
            d["operation"]="print"
            d["length"]=self.dims[0]*self.dims[1]
            d["type"]=self.type
            d["id"]=self.id
            resp = messageSender.sendMessage(d)
            return resp["array"].__str__()

    def __del__(self):
        d=dict()
        d["operation"]="delete"
        d["id"]=self.id
        resp = messageSender.sendMessage(d)

    def __getitem__(self, key):
        d=dict()
        if (isinstance(key,slice)):
            if (len(self.dims)==1):
                d["operation"]="rangeget"
                if ((key.start is not None and key.start<0) or (key.stop is not None and key.stop>self.dims[0])):
                    raise Exception("Index out of range")
                if (key.start is None):
                    d["start"]=0
                else:
                    d["start"]=key.start
                if (key.stop is None):
                    d["stop"]=self.dims[0]
                else:
                    d["stop"]=key.stop
                d["id"]=self.id
                d["type"]=self.type
                resp = messageSender.sendMessage(d)
                return rcarray(resp["id"],self.type,[d["stop"]-d["start"]],1)
        else: 
            if (len(self.dims)==1):
                d["operation"]="getv"
                if (key>=self.dims[0]):
                    raise Exception("Index out of range")
                d["pos"]=key
                d["id"]=self.id
                d["type"]=self.type
                resp = messageSender.sendMessage(d)
                return resp["val"]
    
    def __setitem__(self, key, val):
        d=dict()
        if (isinstance(key,slice)):
            if (self.type!=val.type):
                raise Exception("Incompatible types!")
            if (len(self.dims)==1):
                d["operation"]="rangeset"
                if ((key.start is not None and key.start<0) or (key.stop is not None and key.stop>self.dims[0])):
                    raise Exception("Index out of range")
                if (key.start is None):
                    d["start"]=0
                else:
                    d["start"]=key.start
                if (key.stop is None):
                    d["stop"]=self.dims[0]
                else:
                    d["stop"]=key.stop
                d["id1"]=self.id
                d["id2"]=val.id
                d["type"]=self.type
                messageSender.sendMessage(d)
        else:
            if (len(self.dims)==1):
                d["operation"]="setv"
                if (key>=self.dims[0]):
                    raise Exception("Index out of range")
                d["pos"]=key
                d["id"]=self.id
                d["val"]=val
                d["type"]=self.type
                messageSender.sendMessage(d)

def sum(a : rcarray):
    d = dict()
    if (len(a.dims)==1):
        d["operation"]="sumv"
        d["type"]=a.type
        d["length"]=a.dims[0]
        d["id"]=a.id
        resp = messageSender.sendMessage(d)
        return resp["val"]
    if (len(a.dims)==2):
        d["operation"]="sumv"
        d["type"]=a.type
        d["length"]=a.dims[0]*a.dims[1]
        d["id"]=a.id
        resp = messageSender.sendMessage(d)
        return resp["val"]

def makeRcArray(type : string, dims : list, num : int) -> rcarray:
    d = dict()
    if (len(dims)==1):
        d["operation"]="createv"
        d["type"]=type
        d["length"]=dims[0]
        d["num"]=num
        resp = messageSender.sendMessage(d)
        return rcarray(resp["id"],type,dims,1)

def makeRcArrayFromNumpy(type : string, arr : np.array, dim : int) -> rcarray:
    d = dict()
    if (dim==1):
        d["operation"]="create_from_numpy_v"
        d["type"]=type
        d["length"]=arr.size
        d["array"]=arr.tolist()
        resp = messageSender.sendMessage(d)
        return rcarray(resp["id"],type,[arr.size],1)

def dot(a : rcarray, b: rcarray) -> rcarray:
    if (a.type != b.type):
        raise Exception("Different types!")
    d=dict()
    if (a.dim==2 and b.dim==2 and a.dims[0]==b.dims[0] and a.dims[1]==b.dims[1] and a.dims[0]==a.dims[1]):
        d["operation"]="dotmm"
        d["type"]=a.type
        d["length"]=a.dims[0]*a.dims[1]
        d["id1"]=a.id
        d["id2"]=b.id
        resp = messageSender.sendMessage(d)
        return rcarray(resp["id"],a.type,a.dims,2)
    elif (a.dim==2 and b.dim==2 and a.dims[1]==b.dims[0]):
        d["operation"]="dotNotEqual"
        d["type"]=a.type
        d["adim0"]=a.dims[0]
        d["adim1"]=a.dims[1]
        d["bdim0"]=b.dims[0]
        d["bdim1"]=b.dims[1]
        d["id1"]=a.id
        d["id2"]=b.id
        resp = messageSender.sendMessage(d)
        return rcarray(resp["id"],a.type,[a.dims[0],b.dims[1]],2)
    else:
        raise Exception("Wrong dimensions")   

def makeMatrix(type : string, arr : list, dim : int) -> rcarray:
    d = dict()
    if (len(arr)!=dim):
        raise Exception("Bad dimensions!")
    for a in arr:
        if (a.type!=type):
            raise Exception("Bad type!")
    ids = []
    for a in arr:
        ids.append(a.id)
    d["operation"]="createm"
    d["type"]=type
    d["length"]=arr[0].dims[0]
    d["dim"]=dim
    d["ids"]=ids
    resp = messageSender.sendMessage(d)
    return rcarray(resp["id"],type,[dim,arr[0].dims[0]],2)



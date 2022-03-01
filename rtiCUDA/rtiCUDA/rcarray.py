from array import array
import string
from rtiCUDA import messageSender


class rcarray:
    
    def __init__(self, id : int, type : string, dims : list, dim : int) -> None:
        self.id = id
        self.type = type
        self.dims = dims
        self.dim = dim

    def __add__(self, o):
        d=dict()
        if (len(self.dims)==1 and len(o.dims)==1):
            if (self.dims[0]!=o.dims[0]):
                raise Exception("Arrays must be of same dimensions")
            d["operation"]="binopvv"
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
    
    def __sub__(self, o):
        d=dict()
        if (len(self.dims)==1 and len(o.dims)==1):
            if (self.dims[0]!=o.dims[0]):
                raise Exception("Arrays must be of same dimensions")
            d["operation"]="binopvv"
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

    def __mul__(self, o):
        d=dict()
        if (len(self.dims)==1 and len(o.dims)==1):
            if (self.dims[0]!=o.dims[0]):
                raise Exception("Arrays must be of same dimensions")
            d["operation"]="binopvv"
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


    def __str__(self):
        d=dict()
        if (len(self.dims)==1):
            d["operation"]="print"
            d["length"]=self.dims[0]
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

def makeRcArray(type : string, dims : list, num : int) -> rcarray:
    d = dict()
    if (len(dims)==1):
        d["operation"]="createv"
        d["type"]=type
        d["length"]=dims[0]
        d["num"]=num
        resp = messageSender.sendMessage(d)
        return rcarray(resp["id"],type,dims,1)


from array import array
from email.policy import strict
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
            if (self.type=="double" or self.type=="double"):
                t="double"
            d["op"]="+"
            d["userName"]="andrej"
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
            if (self.type=="double" or self.type=="double"):
                t="double"
            d["op"]="-"
            d["userName"]="andrej"
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
            if (self.type=="double" or self.type=="double"):
                t="double"
            d["op"]="*"
            d["userName"]="andrej"
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
            d["userName"]="andrej"
            d["type"]=self.type
            d["id"]=self.id
            resp = messageSender.sendMessage(d)
            return resp["array"].__str__()

    def __del__(self):
        d=dict()
        d["operation"]="delete"
        d["userName"]="andrej"
        d["id"]=self.id
        resp = messageSender.sendMessage(d)


def makeRcArray(type : string, dims : list, num : int) -> rcarray:
    d = dict()
    if (len(dims)==1):
        d["operation"]="createv"
        d["type"]=type
        d["userName"]="andrej"
        d["length"]=dims[0]
        d["num"]=num
        resp = messageSender.sendMessage(d)
        return rcarray(resp["id"],type,dims,1)


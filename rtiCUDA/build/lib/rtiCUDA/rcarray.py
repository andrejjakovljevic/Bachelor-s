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


def makeRcArray(type : string, dims : list, num : int):
    d = dict()
    if (len(dims)==1):
        d["operation"]="createv"
        d["type"]=type
        d["userName"]="andrej"
        d["length"]=len(dims)
        d["num"]=num
        messageSender.sendMessage(d)

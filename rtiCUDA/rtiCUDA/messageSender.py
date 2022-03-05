import socket
import json
import string

s : socket = None
userName : string = None
isDisconnected : bool


def disconnect():
    global s,userName, isDisconnected
    d = dict()
    d["operation"]="disconnect"
    sendMessage(d)
    isDisconnected = True
    s=None


def connect(un : string):
    global s,userName,isDisconnected
    s=socket.socket()
    s.connect(('127.0.0.1',12121))
    userName = un
    d = dict()
    d["operation"]="connect"
    isDisconnected=False
    sendMessage(d)

def sendMessage(d : dict) -> dict:
    if (isDisconnected):
        if (d["operation"]=="delete"):
            return
        else:
            raise Exception("Disconnected already")
    d["userName"]=userName
    sender = json.dumps(d)
    s.send(sender.encode())
    data = s.recv(100250).decode()
    helper = json.loads(data)
    if (helper["message"]=="error"):
        raise Exception(helper["text"])
    return helper
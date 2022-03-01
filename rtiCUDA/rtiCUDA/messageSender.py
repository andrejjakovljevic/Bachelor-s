import socket
import json

def sendMessage(d : dict) -> dict:
    s = socket.socket()
    s.connect(('127.0.0.1',12121))
    sender = json.dumps(d)
    s.send(sender.encode())
    data = s.recv(1025).decode()
    helper = json.loads(data)
    if (helper["message"]=="error"):
        raise Exception(helper["text"])
    return helper
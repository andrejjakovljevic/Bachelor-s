#include <iostream>
#include "BasicArray.h"
#include "BasicOperations.h"
#include "SymTab.h"
#include "Users.h"
#include "Conversions.h"
#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <json.hpp>
#define PORT 12121
using namespace std;
using json = nlohmann::json;

void test()
{
    UserDictionary* users = UserDictionary::getInstance();
    users->addUser("andrej");
    SymbolTable* symTab = users->getSymTable("andrej");
    int type = 0;
    int dim = 1;
    int d[3] = {1,2,3};
    void* data = (void*)d;
    int dims[1] = {3};
    BasicArray* ba1 = new BasicArray(type,dims,dim,data);
    int d2[3] = {3,4,5};
    BasicArray* ba2 = new BasicArray(type, dims, dim, (void*)d2);
    int id1 = symTab->addArray(ba1);
    int id2 = symTab->addArray(ba2);
    BasicArray* t1 = symTab->getArray(id1);
    BasicArray* t2 = symTab->getArray(id2);
    int* c = (int*)malloc(3*sizeof(int));
    vecAddIntCPU(Converter::voidToIntArray(t1->getData()),Converter::voidToIntArray(t2->getData()),c,3);
    for (int i=0;i<3;i++)
    {
        cout << c[i] << " ";
    }
    cout << endl;
}

void do_calculations(char* buffer, int new_socket)
{
    auto nesto = json::parse(buffer);
    cout << nesto["operation"] << endl;
    if (nesto["operation"]=="createv")
    {
        int k = nesto["num"];
        int length = nesto["length"];
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            // OVDE IDE GRESKA
            cout << "greska" << endl;
            return;
        }
        int type;
        int dim = 1;
        int dims[1] = {length};
        void* d;
        if (nesto["type"]=="int")
        {   
            type=0;
            d = malloc(sizeof(int)*length);
            initVecIntCPU((int*)d, k, length);
        }
        else if (nesto["type"]=="double")
        {
            type=1;
            d = malloc(sizeof(double)*length);
            initVecDoubleCPU((double*)d, k, length);
        }
        BasicArray* ba = new BasicArray(type, dims, 1, d);
        int id = st->addArray(ba);
        json j;
        j["message"]="OK";
        j["id"]=id;
        send(new_socket , j.dump().c_str() , strlen(j.dump().c_str()) , 0 );
    }
    else if (nesto["operation"]=="binopvv")
    {
        int length = nesto["length"];
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            // OVDE IDE GRESKA
            cout << "greska" << endl;
            return;
        }
        int dim = 1;
        int dims[1] = {length};
        int type;
        void* d;
        if (nesto["type"]=="int")
        {   
            type=0;
            d = malloc(sizeof(int)*length);
        }
        else if (nesto["type"]=="double")
        {
            type=1;
            d = malloc(sizeof(double)*length);
        }
        BasicArray* ba = new BasicArray(type, dims, 1, d);
        BasicArray* a = st->getArray(nesto["id1"]);
        BasicArray* b = st->getArray(nesto["id2"]);
        if (a==nullptr || b==nullptr)
        {
            // OVDE IDE GRESKA
            cout << "greska" << endl;
            return;
        }
        if (a->getType()==INT && b->getType()==INT)
        {
            if (nesto["op"]=="+")
            {
                vecAddIntCPU((int*)a->getData(), (int*)b->getData(), (int*)ba->getData(), length);
            }
            else if (nesto["op"]=="-")
            {
                vecSubIntCPU((int*)a->getData(), (int*)b->getData(), (int*)ba->getData(), length);
            }
            else if (nesto["op"]=="*")
            {
                vecMulIntCPU((int*)a->getData(), (int*)b->getData(), (int*)ba->getData(), length);
            }
        }
        else if (a->getType()==DOUBLE && b->getType()==DOUBLE)
        {
            if (nesto["op"]=="+")
            {
                vecAddDoubleCPU((double*)a->getData(), (double*)b->getData(), (double*)ba->getData(), length);
            }
            else if (nesto["op"]=="-")
            {
                vecSubDoubleCPU((double*)a->getData(), (double*)b->getData(), (double*)ba->getData(), length);
            }
            else if (nesto["op"]=="*")
            {
                vecMulDoubleCPU((double*)a->getData(), (double*)b->getData(), (double*)ba->getData(), length);
            }
        }
        else if (a->getType()==DOUBLE && b->getType()==INT)
        {
            if (nesto["op"]=="+")
            {
                vecAddDoubleIntCPU((double*)a->getData(), (int*)b->getData(), (double*)ba->getData(), length);
            }
            else if (nesto["op"]=="-")
            {
                vecSubDoubleIntCPU((double*)a->getData(), (int*)b->getData(), (double*)ba->getData(), length);
            }
            else if (nesto["op"]=="*")
            {
                vecMulDoubleIntCPU((double*)a->getData(), (int*)b->getData(), (double*)ba->getData(), length);
            }
        }
        else if (a->getType()==INT && b->getType()==DOUBLE)
        {
            if (nesto["op"]=="+")
            {
                vecAddDoubleIntCPU((double*)b->getData(), (int*)a->getData(), (double*)ba->getData(), length);
            }
            else if (nesto["op"]=="-")
            {
                vecSubIntDoubleCPU((int*)a->getData(), (double*)b->getData(), (double*)ba->getData(), length);
            }
            else if (nesto["op"]=="*")
            {
                vecMulDoubleIntCPU((double*)b->getData(), (int*)a->getData(), (double*)ba->getData(), length);
            }
        }
        int id = st->addArray(ba);
        json j;
        j["message"]="OK";
        j["id"]=id;
        send(new_socket , j.dump().c_str() , strlen(j.dump().c_str()) , 0 );
    }
    else if (nesto["operation"]=="print")
    {
        int length = nesto["length"];
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            // OVDE IDE GRESKA
            cout << "greska" << endl;
            return;
        }
        BasicArray* a = st->getArray(nesto["id"]);
        if (a==nullptr)
        {
            // OVDE IDE GRESKA
            cout << "greska" << endl;
            return;
        }
        json j;
        if (nesto["type"]=="double")
        {
            double* d = Converter::voidToDoubleArray(a->getData());
            vector<double> ret;
            for (int i=0;i<length;i++)
            {
                ret.push_back(d[i]);
            }
            j["message"]="OK";
            j["array"]=ret;
        }
        else if (nesto["type"]=="int")
        {
            int* d = Converter::voidToIntArray(a->getData());
            vector<int> ret;
            for (int i=0;i<length;i++)
            {
                ret.push_back(d[i]);
            }
            j["message"]="OK";
            j["array"]=ret;
        }
        send(new_socket , j.dump().c_str() , strlen(j.dump().c_str()) , 0 );
    }
}

void network_communication()
{
    int server_fd, new_socket, valread;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
       
    // Creating socket file descriptor
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0)
    {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
       
    // Forcefully attaching socket to the port 8080
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT,
                                                  &opt, sizeof(opt)))
    {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons( PORT );
       
    // Forcefully attaching socket to the port 8080
    if (bind(server_fd, (struct sockaddr *)&address, 
                                 sizeof(address))<0)
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    if (listen(server_fd, 3) < 0)
    {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    if ((new_socket = accept(server_fd, (struct sockaddr *)&address, 
                       (socklen_t*)&addrlen))<0)
    {
        perror("accept");
        exit(EXIT_FAILURE);
    }
    while (1)
    {
        char buffer[1024] = {0};
        valread = read( new_socket , buffer, 1024);
        cout << "buffer=" << buffer << endl;
        if (valread<=0) return;
        do_calculations(buffer,new_socket);
    }
}

int main()
{
    UserDictionary* users = UserDictionary::getInstance();
    users->addUser("andrej");
    network_communication();
}
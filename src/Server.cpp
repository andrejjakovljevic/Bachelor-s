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
#include <pthread.h>
#include <arpa/inet.h>    //close 
#include <chrono>
#include <unistd.h>
#define PORT 12121
using namespace std;
using json = nlohmann::json;

bool trace=false;

void send_error(string errMes, int new_socket)
{
    json j;
    j["message"]="error";
    j["text"]=errMes;
    send(new_socket , j.dump().c_str() , strlen(j.dump().c_str()) , 0 );
}

chrono::_V2::steady_clock::time_point start;
chrono::_V2::steady_clock::time_point stop;
long long int overall = 0;

void do_calculations(char* buffer, int new_socket)
{
    if (trace)
    {
        start = chrono::steady_clock::now();
    }
    auto nesto = json::parse(buffer);
    //cout << nesto["operation"] << endl;
    json j;
    if (nesto["operation"]=="createv")
    {
        int length = nesto["length"];
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        int type;
        int dim = 1;
        int dims[1] = {length};
        void* d;
        if (nesto["type"]=="int")
        {   
            int k = nesto["num"];
            type=0;
            d = malloc(sizeof(int)*length);
            initVecIntCPU((int*)d, k, length);
        }
        else if (nesto["type"]=="double")
        {
            double k = nesto["num"];
            type=1;
            d = malloc(sizeof(double)*length);
            initVecDoubleCPU((double*)d, k, length);
        }
        BasicArray* ba = new BasicArray(type, dims, 1, d);
        int id = st->addArray(ba);
        just_front(ba->data,ba->d_data,ba->size());
        j["message"]="OK";
        j["id"]=id;
    }
    else if (nesto["operation"]=="binopvv")
    {
        int length = nesto["length"];
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
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
            send_error("Array does not exist",new_socket);
            return;
        }
        if (a->getType()==INT && b->getType()==INT)
        {
            if (nesto["op"]=="+")
            {
                vecAddIntCPU((int*)a->getd_Data(), (int*)b->getd_Data(), (int*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="-")
            {
                vecSubIntCPU((int*)a->getd_Data(), (int*)b->getd_Data(), (int*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="*")
            {
                vecMulIntCPU((int*)a->getd_Data(), (int*)b->getd_Data(), (int*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="/")
            {
                vecDivIntCPU((int*)a->getd_Data(), (int*)b->getd_Data(), (double*)ba->getd_Data(), length);
            }
            //just_return(ba->getData(),ba->d_data,ba->size());
        }
        else if (a->getType()==DOUBLE && b->getType()==DOUBLE)
        {
            if (nesto["op"]=="+")
            {
               vecAddDoubleCPU((double*)a->getd_Data(), (double*)b->getd_Data(), (double*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="-")
            {
                vecSubDoubleCPU((double*)a->getd_Data(), (double*)b->getd_Data(), (double*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="*")
            {
                vecMulDoubleCPU((double*)a->getd_Data(), (double*)b->getd_Data(), (double*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="/")
            {
                vecDivDoubleCPU((double*)a->getd_Data(), (double*)b->getd_Data(), (double*)ba->getd_Data(), length);
            }
            //just_return(ba->getData(),ba->d_data,ba->size());
        }
        else if (a->getType()==DOUBLE && b->getType()==INT)
        {
            if (nesto["op"]=="+")
            {
                vecAddDoubleIntCPU((double*)a->getd_Data(), (int*)b->getd_Data(), (double*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="-")
            {
                vecSubDoubleIntCPU((double*)a->getd_Data(), (int*)b->getd_Data(), (double*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="*")
            {
                vecMulDoubleIntCPU((double*)a->getd_Data(), (int*)b->getd_Data(), (double*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="/")
            {
                vecDivDoubleIntCPU((double*)a->getd_Data(), (int*)b->getd_Data(), (double*)ba->getd_Data(), length);
            }
            //just_return(ba->getData(),ba->d_data,ba->size());
        }
        else if (a->getType()==INT && b->getType()==DOUBLE)
        {
            if (nesto["op"]=="+")
            {
                vecAddDoubleIntCPU((double*)b->getd_Data(), (int*)a->getd_Data(), (double*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="-")
            {
                vecSubIntDoubleCPU((int*)a->getd_Data(), (double*)b->getd_Data(), (double*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="*")
            {
                vecMulDoubleIntCPU((double*)b->getd_Data(), (int*)a->getd_Data(), (double*)ba->getd_Data(), length);
            }
            else if (nesto["op"]=="/")
            {
                vecDivDoubleIntCPU((double*)a->getd_Data(), (int*)b->getd_Data(), (double*)ba->getd_Data(), length);
            }
            //just_return(ba->getData(),ba->d_data,ba->size());
        }
        int id = st->addArray(ba);
        j["message"]="OK";
        j["id"]=id;
    }
    else if (nesto["operation"]=="print")
    {
        int length = nesto["length"];
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        BasicArray* a = st->getArray(nesto["id"]);
        if (a==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        just_return(a->data,a->d_data,a->size());
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
    }
    else if (nesto["operation"]=="delete")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        BasicArray* a = st->getArray(nesto["id"]);
        if (a==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        st->removeArray(nesto["id"]);
        j["message"]="OK";
    }
    else if (nesto["operation"]=="connect")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st!=nullptr)
        {
            send_error("UserName already exists",new_socket);
            return;
        }
        users->addUser(nesto["userName"]);
        j["message"]="OK";
    }
    else if (nesto["operation"]=="disconnect")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName already exists",new_socket);
            return;
        }
        users->deleteUser(nesto["userName"]);
        j["message"]="OK";
    }
    else if (nesto["operation"]=="setv")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        BasicArray* a = st->getArray(nesto["id"]);
        if (a==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        int pos = nesto["pos"];
        string type = nesto["type"];
        just_return(a->data,a->d_data,a->size());
        if (type=="int")
        {
            int x = nesto["val"];
            int* d = Converter::voidToIntArray(a->getData());
            d[pos]=x;
        }
        else if (type=="double")
        {
            double x = nesto["val"];
            double* d = Converter::voidToDoubleArray(a->getData());
            d[pos]=x;
        }
        just_front(a->data,a->d_data,a->size());
        j["message"]="OK";
    }
    else if (nesto["operation"]=="getv")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        BasicArray* a = st->getArray(nesto["id"]);
        if (a==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        just_return(a->data,a->d_data,a->size());
        int pos = nesto["pos"];
        string type = nesto["type"];
        j["message"]="OK";
        if (type=="int")
        {
            int* d = Converter::voidToIntArray(a->getData());
            int x = d[pos];
            j["val"]=x;
        }
        else if (type=="double")
        {
            double* d = Converter::voidToDoubleArray(a->getData());
            double x = d[pos];
            j["val"]=x;
        }
    }
    else if (nesto["operation"]=="sumv")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        BasicArray* a = st->getArray(nesto["id"]);
        if (a==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        int length = nesto["length"];
        j["message"]="OK";
        if (nesto["type"]=="int")
        {
            int res = vecSumInt((int*)a->d_data, length);
            j["val"]=res;
        }
        else if (nesto["type"]=="double")
        {
            double res = vecSumDouble((double*)a->d_data,length);
            j["val"]=res;
        }
    }
    else if (nesto["operation"]=="create_from_numpy_v")
    {
        int length = nesto["length"];
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
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
            int* data = Converter::voidToIntArray(d);
            for (int i=0;i<length;i++)
            {
                data[i]=nesto["array"][i];
            }
        }
        else if (nesto["type"]=="double")
        {
            type=1;
            d = malloc(sizeof(double)*length);
            double* data = Converter::voidToDoubleArray(d);
            for (int i=0;i<length;i++)
            {
                data[i]=nesto["array"][i];
            }
        }
        BasicArray* ba = new BasicArray(type, dims, 1, d);
        int id = st->addArray(ba);
        just_front(ba->data,ba->d_data,ba->size());
        j["message"]="OK";
        j["id"]=id;
    }
    else if (nesto["operation"]=="dotmm")
    {
        int length = nesto["length"];
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        int dim = 1;
        int dims[1] = {length};
        int type;
        void* d;
        int k = sqrt(length);
        if (k*k!=length)
        {
            send_error("Dimensions of the matrix are not ok!",new_socket);
            return;
        }
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
        BasicArray* a = st->getArray(nesto["id1"]);
        BasicArray* b = st->getArray(nesto["id2"]);
        if (a==nullptr || b==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        BasicArray* ba = new BasicArray(type, dims, 1, d);
        if (a->getType()==INT && b->getType()==INT)
        {
            dot_prodIntCPU((int*)a->d_data,(int*)b->d_data,(int*)ba->d_data,k,k,k,k,k,k);
        }
        else if (a->getType()==DOUBLE && b->getType()==DOUBLE)
        {
            dot_prodDoubleCPU((double*)a->d_data,(double*)b->d_data,(double*)ba->d_data,k,k,k,k,k,k);
        }
        int id = st->addArray(ba);
        j["message"]="OK";
        j["id"]=id;
    }
    if (nesto["operation"]=="dotNotEqual")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        int dim = 1;
        int adim0 = nesto["adim0"];
        int adim1 = nesto["adim1"];
        int bdim0 = nesto["bdim0"];
        int bdim1 = nesto["bdim1"];
        int length = adim0*bdim1;
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
        BasicArray* a = st->getArray(nesto["id1"]);
        BasicArray* b = st->getArray(nesto["id2"]);
        if (a==nullptr || b==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        BasicArray* ba = new BasicArray(type, dims, 1, d);
        if (a->getType()==INT && b->getType()==INT)
        {
            dot_prodIntCPU((int*)a->d_data,(int*)b->d_data,(int*)ba->d_data,adim0,adim1,bdim0,bdim1,adim0,bdim1);
        }
        if (a->getType()==DOUBLE && b->getType()==DOUBLE)
        {
            dot_prodDoubleCPU((double*)a->d_data,(double*)b->d_data,(double*)ba->d_data,adim0,adim1,bdim0,bdim1,adim0,bdim1);
        }
        int id = st->addArray(ba);
        j["message"]="OK";
        j["id"]=id;
    }
    if (nesto["operation"]=="createm")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        int length = nesto["length"];
        int dim = nesto["dim"];
        int type;
        void* d;
        if (nesto["type"]=="int")
        {   
            type=0;
            d = malloc(sizeof(int)*length*dim);
            int* data = (int*)d;
            int s=0;
            for (int i=0;i<dim;i++)
            {
                BasicArray* ba = st->getArray(nesto["ids"][i]);
                just_return(ba->data,ba->d_data,ba->size());
                int* pom_data = (int*)ba->data;
                for (int j=0;j<ba->dims[0];j++)
                {
                    data[s]=pom_data[j];
                    s++;
                }
            }
        }
        else if (nesto["type"]=="double")
        {
            type=1;
            d = malloc(sizeof(double)*length*dim);
            double* data = (double*)d;
            int s=0;
            for (int i=0;i<dim;i++)
            {
                BasicArray* ba = st->getArray(nesto["ids"][i]);
                just_return(ba->data,ba->d_data,ba->size());
                double* pom_data = (double*)ba->data;
                for (int j=0;j<ba->dims[0];j++)
                {
                    data[s]=pom_data[j];
                    s++;
                }
            }
        }
        int dims[1]={length*dim};
        BasicArray* ba = new BasicArray(type, dims, 1, d);
        int id = st->addArray(ba);
        just_front(ba->data,ba->d_data,ba->size());
        j["message"]="OK";
        j["id"]=id;
    }
    if (nesto["operation"]=="rangeget")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        BasicArray* a = st->getArray(nesto["id"]);
        if (a==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        int start = nesto["start"];
        int stop = nesto["stop"];
        void* d;
        void* d_d;
        int length=stop-start;
        int dim = 1;
        int dims[1] = {length};
        int type;
        if (nesto["type"]=="int")
        {
            type=0;
            d = malloc(sizeof(int)*length*dim);
            d_d = (void*)spliceInt((int*)a->d_data,start,stop);
        }
        else if (nesto["type"]=="double")
        {
            type=1;
            d = malloc(sizeof(int)*length*dim);
            d_d=(void*)spliceDouble((double*)a->d_data,start,stop);
        }
        BasicArray* ba = new BasicArray(type, dims, 1, d);
        int id = st->addArray(ba);
        ba->d_data=d_d;
        j["message"]="OK";
        j["id"]=id;
    }
    else if (nesto["operation"]=="rangeset")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        BasicArray* a = st->getArray(nesto["id1"]);
        BasicArray* b = st->getArray(nesto["id2"]);
        if (a==nullptr || b==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        int start = nesto["start"];
        int stop = nesto["stop"];
        if (nesto["type"]=="int")
        {
            rangeSetInt((int*)a->d_data, (int*)b->d_data, start, stop);
        }
        else if (nesto["type"]=="double")
        {
            rangeSetDouble((double*)a->d_data, (double*)b->d_data, start, stop);
        }
        j["message"]="OK";
    }
    else if (nesto["operation"]=="transpose")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        BasicArray* a = st->getArray(nesto["id"]);
        if (a==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        int width = nesto["width"];
        int height = nesto["height"];
        if (nesto["type"]=="int")
        {
            transposeInplaceIntCPU((int*)a->d_data, width, height);
        }
        else if (nesto["type"]=="double")
        {
            transposeInplaceDoubleCPU((double*)a->d_data, width, height);
        }
        j["message"]="OK";
    }
    else if (nesto["operation"]=="binopvs")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        double x = nesto["x"];
        BasicArray* a = st->getArray(nesto["id"]);
        if (a==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        int length=nesto["length"];
        int dims[1] = {length};
        int type=1;
        void* d = malloc(sizeof(double)*length);
        BasicArray* ba = new BasicArray(type, dims, 1, d);
        if (nesto["op"]=="*")
        {
            if (nesto["type"]=="int")
            {
                mulScalarIntDoubleCPU((int*)a->d_data, x, (double*)ba->d_data,length);
            }
            else if (nesto["type"]=="double")
            {
                mulScalarDoubleDoubleCPU((double*)a->d_data, x, (double*)ba->d_data,length);
            }
        }
        if (nesto["op"]=="/")
        {
            if (nesto["type"]=="int")
            {
                divScalarIntDoubleCPU((int*)a->d_data, x, (double*)ba->d_data,length);
            }
            else if (nesto["type"]=="double")
            {
                divScalarDoubleDoubleCPU((double*)a->d_data, x, (double*)ba->d_data,length);
            }
        }
        int id = st->addArray(ba);
        j["message"]="OK";
        j["id"]=id;
    }
    else if (nesto["operation"]=="submatrix")
    {
        UserDictionary* users = UserDictionary::getInstance();
        SymbolTable* st = users->getSymTable(nesto["userName"]);
        if (st==nullptr)
        {
            send_error("UserName does not exist",new_socket);
            return;
        }
        BasicArray* a = st->getArray(nesto["id"]);
        if (a==nullptr)
        {
            send_error("Array does not exist",new_socket);
            return;
        }
        int x1 = nesto["x1"];
        int y1 = nesto["y1"];
        int xd = nesto["xd"];
        int yd = nesto["yd"];
        int x = nesto["x"];
        int y = nesto["y"];
        int length = xd*yd;
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
        if (ba->getType()==INT)
        {
            getSubMatrixIntCPU((int*)a->getd_Data(),(int*)ba->getd_Data(),x1,y1,xd,yd,x,y);
        }
        else if (ba->getType()==DOUBLE)
        {
            getSubMatrixDoubleCPU((double*)a->getd_Data(),(double*)ba->getd_Data(),x1,y1,xd,yd,x,y);
        }
        int id = st->addArray(ba);
        j["message"]="OK";
        j["id"]=id;
    }
    else if (nesto["operation"]=="start_tracing")
    {
        trace=true;
        j["message"]="OK";
    }
    else if (nesto["operation"]=="stop_tracing")
    {
        trace=false;
        j["message"]="OK";
        j["val"]=overall;
        overall=0;
    }
    if (!check_error())
    {
        send(new_socket , j.dump().c_str() , strlen(j.dump().c_str()) , 0 );
    }
    else 
    {
        send_error("Server error!",new_socket);
    }
    if (trace)
    {
        stop = chrono::steady_clock::now();
        overall+=chrono::duration_cast<chrono::milliseconds>(stop - start).count();
    }
}

char buffer[100250];  //data buffer of 100K 

void network_communication()
{
    int opt = 1;  
    int master_socket , addrlen , new_socket , client_socket[30] , 
          max_clients = 30 , activity, i , valread , sd;  
    int max_sd;  
    struct sockaddr_in address;  
         
         
    //set of socket descriptors 
    fd_set readfds;  
         
     
    //initialise all client_socket[] to 0 so not checked 
    for (i = 0; i < max_clients; i++)  
    {  
        client_socket[i] = 0;  
    }  
         
    //create a master socket 
    if( (master_socket = socket(AF_INET , SOCK_STREAM , 0)) == 0)  
    {  
        perror("socket failed");  
        exit(EXIT_FAILURE);  
    }  
     
    //set master socket to allow multiple connections , 
    //this is just a good habit, it will work without this 
    if( setsockopt(master_socket, SOL_SOCKET, SO_REUSEADDR, (char *)&opt, 
          sizeof(opt)) < 0 )  
    {  
        perror("setsockopt");  
        exit(EXIT_FAILURE);  
    }  
     
    //type of socket created 
    address.sin_family = AF_INET;  
    address.sin_addr.s_addr = INADDR_ANY;  
    address.sin_port = htons( PORT );  
         
    //bind the socket to localhost port 8888 
    if (bind(master_socket, (struct sockaddr *)&address, sizeof(address))<0)  
    {  
        perror("bind failed");  
        exit(EXIT_FAILURE);  
    }  
    printf("Listener on port %d \n", PORT);  
         
    //try to specify maximum of 3 pending connections for the master socket 
    if (listen(master_socket, 3) < 0)  
    {  
        perror("listen");  
        exit(EXIT_FAILURE);  
    }  
         
    //accept the incoming connection 
    addrlen = sizeof(address);  
    printf("Waiting for connections ...");  
         
    while(1)  
    {  
        //clear the socket set 
        FD_ZERO(&readfds);  
     
        //add master socket to set 
        FD_SET(master_socket, &readfds);  
        max_sd = master_socket;  
             
        //add child sockets to set 
        for ( i = 0 ; i < max_clients ; i++)  
        {  
            //socket descriptor 
            sd = client_socket[i];  
                 
            //if valid socket descriptor then add to read list 
            if(sd > 0)  
                FD_SET( sd , &readfds);  
                 
            //highest file descriptor number, need it for the select function 
            if(sd > max_sd)  
                max_sd = sd;  
        }  
     
        //wait for an activity on one of the sockets , timeout is NULL , 
        //so wait indefinitely 
        activity = select( max_sd + 1 , &readfds , NULL , NULL , NULL);  
       
        if ((activity < 0) && (errno!=EINTR))  
        {  
            printf("select error");  
        }  
             
        //If something happened on the master socket , 
        //then its an incoming connection 
        if (FD_ISSET(master_socket, &readfds))  
        {  
            if ((new_socket = accept(master_socket, 
                    (struct sockaddr *)&address, (socklen_t*)&addrlen))<0)  
            {  
                perror("accept");  
                exit(EXIT_FAILURE);  
            }  
             
            //inform user of socket number - used in send and receive commands 
            printf("New connection , socket fd is %d , ip is : %s , port : %d\n" , new_socket , inet_ntoa(address.sin_addr) , ntohs
                  (address.sin_port));  
                 
            //add new socket to array of sockets 
            for (i = 0; i < max_clients; i++)  
            {  
                //if position is empty 
                if( client_socket[i] == 0 )  
                {  
                    client_socket[i] = new_socket;  
                    printf("Adding to list of sockets as %d\n" , i);  
                         
                    break;  
                }  
            }  
        }  
             
        //else its some IO operation on some other socket
        for (i = 0; i < max_clients; i++)  
        {  
            sd = client_socket[i];  
                 
            if (FD_ISSET( sd , &readfds))  
            {  
                //Check if it was for closing , and also read the 
                //incoming message 
                if ((valread = read( sd , buffer, 100250)) == 0)  
                {  
                    //Somebody disconnected , get his details and print 
                    getpeername(sd , (struct sockaddr*)&address , \
                        (socklen_t*)&addrlen);  
                    printf("Host disconnected , ip %s , port %d \n" , 
                          inet_ntoa(address.sin_addr) , ntohs(address.sin_port));  
                         
                    //Close the socket and mark as 0 in list for reuse 
                    close( sd );  
                    client_socket[i] = 0;  
                }  
                     
                //Echo back the message that came in 
                else 
                {  
                    //set the string terminating NULL byte on the end 
                    //of the data read 
                    buffer[valread] = '\0';  
                    do_calculations(buffer,sd);
                }  
            }  
        }  
    }  
}

int main()
{
    network_communication();
}
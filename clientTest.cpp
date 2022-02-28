#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <json.hpp>
#include <iostream>
#include <cstring>
#define PORT 12121
using namespace std;
using json = nlohmann::json;

int main(int argc, char const *argv[])
{
    int sock = 0, valread;
    struct sockaddr_in serv_addr;
    char buffer[1024] = {0};
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        printf("\n Socket creation error \n");
        return -1;
    }
   
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    // Convert IPv4 and IPv6 addresses from text to binary form
    if(inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr)<=0) 
    {
        printf("\nInvalid address/ Address not supported \n");
        return -1;
    }
   
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
        printf("\nConnection Failed \n");
        return -1;
    }
    int br=0;
    json j;
    j["operation"]="createv";
    j["type"]="int";
    j["userName"]="andrej";
    j["length"]=3;
    j["num"]=1;
    send(sock , j.dump().c_str() , strlen(j.dump().c_str()) , 0 );
    read( sock , buffer, 1024);
    auto j2 = json::parse(buffer);
    cout << j2["message"] << " " << j2["id"] << endl;
    json j1;
    j1["operation"]="createv";
    j1["type"]="int";
    j1["userName"]="andrej";
    j1["length"]=3;
    j1["num"]=4;
    send(sock , j1.dump().c_str() , strlen(j1.dump().c_str()) , 0 );
    read( sock , buffer, 1024);
    auto j3 = json::parse(buffer);
    cout << j3["message"] << " " << j3["id"] << endl;
    json j4;
    j4["operation"]="binopvv";
    j4["op"]="+";
    j4["id1"]=0;
    j4["id2"]=1;
    j4["type"]="int";
    j4["length"]=3;
    j4["userName"]="andrej";
    send(sock , j4.dump().c_str() , strlen(j4.dump().c_str()) , 0 );
    read( sock , buffer, 1024);
    auto j5 = json::parse(buffer);
    cout << j5["message"] << " " << j5["id"] << endl;
    json j6;
    j6["operation"]="print";
    j6["length"]=3;
    j6["id"]=2;
    j6["type"]="int";
    j6["userName"]="andrej";
    send(sock , j6.dump().c_str() , strlen(j6.dump().c_str()) , 0 );
    read( sock , buffer, 1024);
    auto j7 = json::parse(buffer);
    cout << j7["message"] << " " << j7["array"] << endl;
    /*j["operation"]="createv";
    j["type"]="double";
    j["userName"]="andrej";
    j["length"]=3;
    while(br++<2)
    {
        json j;
        j["operation"]="addvv";
        j["id1"]=0;
        j["id2"]=1;
        cout << j.dump() << endl;
        cout << strlen(j.dump().c_str()) << endl;
        //send(sock , hello , strlen(hello) , 0 );
    }*/
   /* printf("Hello message sent\n");
    valread = read( sock , buffer, 1024);
    printf("%s\n",buffer );*/
    return 0;
}

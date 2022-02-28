#ifndef USERS_H
#define USERS_H
#include <iostream>
#include <map>
#include <unordered_map>
#include "SymTab.h"
using namespace std;

class UserDictionary
{
    map<string, SymbolTable*> users;
    static UserDictionary* instance;

public:
    int addUser(string userName);
    void deleteUser(string userName);
    static UserDictionary* getInstance();
    SymbolTable* getSymTable(string userName);
};

#endif
#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H
#include <iostream>
#include <map>
#include <unordered_map>
#include "BasicArray.h"
using namespace std;

class SymbolTable
{
    static int sid;
    unordered_map<int,BasicArray*> mapa;
    string user;

public:

    SymbolTable(string user);

    int addArray(BasicArray* ba);

    BasicArray* getArray(int sid);

    void removeArray(int sid);

    ~SymbolTable();

};

#endif

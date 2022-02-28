#include "Users.h"

UserDictionary* UserDictionary::instance=nullptr;

int UserDictionary::addUser(string userName)
{
    if (users.find(userName)!=users.end())
    {
        return -1;
    }
    users[userName]=new SymbolTable(userName);
    return 0;
}

void UserDictionary::deleteUser(string userName)
{
    if (users.find(userName)==users.end())
    {
        // OVDE IDU GRESKE
    }
    SymbolTable* st = users[userName];
    delete st;
    users.erase(userName);
}

UserDictionary* UserDictionary::getInstance()
{
    if (instance==nullptr)
    {
        instance=new UserDictionary();
    }
    return instance;
}

SymbolTable* UserDictionary::getSymTable(string userName)
{
    if (users.find(userName)==users.end())
    {
        return nullptr;
    }
    return users[userName];
}
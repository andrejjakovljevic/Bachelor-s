#include "SymTab.h"

int SymbolTable::sid=0;

int SymbolTable::addArray(BasicArray* ba)
{
    mapa[sid]=ba;
    ba->setId(sid);
    sid++;
    return ba->getId();
}

BasicArray* SymbolTable::getArray(int sid)
{
    if (mapa.find(sid)!=mapa.end()) return mapa[sid];
    else return nullptr;
}

SymbolTable::SymbolTable(string user)
{
    this->user=user;
}

SymbolTable::~SymbolTable()
{
    for (auto& u : this->mapa)
    {
        if (u.second!=nullptr) delete u.second;
    }
}

void SymbolTable::removeArray(int sid)
{
    if (mapa.find(sid)!=mapa.end())
    {
        delete mapa[sid];
        mapa.erase(sid);
    }

}
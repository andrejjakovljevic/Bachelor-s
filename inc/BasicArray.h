#ifndef BASIC_ARRAY_H
#define BASIC_ARRAY_H
#include "string.h"
#include "BasicOperations.h"
#include <cstdlib>

typedef enum {INT, DOUBLE} Type; // 0 - INS, 1 - DOUBLE

class BasicArray
{

public:
    Type type;
    int dim;
    void* data;
    int* dims;
    int id;
    void* d_data;


    void setId(int id)
    {
        this->id = id;
    }

    int getId()
    {
        return id;
    }

    int getDim()
    {
        return dim;
    }

    Type getType()
    {
        return type;
    }

    int sizeType()
    {
        if (type==INT) return sizeof(int);
        if (type==DOUBLE) return sizeof(double);
        return 0;
    }

    int size();

    BasicArray(int type, int* dims, int dim, void* data);

    void* getData()
    {
        return data;
    }

    void* getd_Data()
    {
        return d_data;
    }

    ~BasicArray();

};

#endif
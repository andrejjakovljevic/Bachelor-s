#include "BasicArray.h"
#include "BasicOperations.h"
#include <iostream>
using namespace std;
int BasicArray::size()
{
    int s = 0;
    int sT = sizeType();
    for (int i=0;i<dim;i++)
    {
        s+=dims[i]*sT;
    }
    return s;
}

BasicArray::BasicArray(int type, int* dims, int dim, void* data)
{
    this->dim=dim;
    if (type==0) this->type=INT;
    if (type==1) this->type=DOUBLE;
    this->dims=(int*)malloc(sizeof(int)*dim);
    for (int i=0;i<dim;i++)
    {
        this->dims[i]=dims[i];
    }
    this->data=data;
    if (size()+trensize< (long long)3*1024*1024*1024)
    {
        copy_front(data,d_data,size());
    }
}

BasicArray::~BasicArray()
{
    copy_back(data,d_data,size());
    free(data);
    free(dims);
}
#include "BasicArray.h"

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
    this->dims=dims;
    this->data=data;
}
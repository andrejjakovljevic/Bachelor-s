#ifndef CONVERSION_H
#define CONVERSION_H

class Converter
{
public:
    inline static double* voidToDoubleArray(void* data)
    {
        return (double*)data;
    }

    inline static int* voidToIntArray(void* data)
    {
        return (int*) data;
    }

    inline static double** voidToDoubleMatrix(void* data)
    {
        return (double**)data;
    }

    inline static int** voidToIntMatrix(void* data)
    {
        return (int**)data;
    }
};

#endif
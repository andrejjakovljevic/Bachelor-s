#ifndef BASIC_OP
#define BASIC_OP

extern void vecAddDoubleCPU(double *a, double *b, double *c, int n);
extern void vecSubDoubleCPU(double *a, double *b, double *c, int n);
extern void vecMulDoubleCPU(double *a, double *b, double *c, int n);
extern void vecAddIntCPU(int *a, int *b, int *c, int n);
extern void vecSubIntCPU(int *a, int *b, int *c, int n);
extern void vecMulIntCPU(int *a, int *b, int *c, int n);
extern void initVecIntCPU(int *a, int x, int n);
extern void initVecDoubleCPU(double* a, double x, int n);
extern void vecAddDoubleIntCPU(double *a, int *b, double *c, int n);
extern void vecMulDoubleIntCPU(double *a, int *b, double *c, int n);
extern void vecSubDoubleIntCPU(double *a, int *b, double *c, int n);
extern void vecSubIntDoubleCPU(int *a, double *b, double *c, int n);
extern void vecDivDoubleCPU(double* a, double *b, double *c, int n);
extern void vecDivIntCPU(int* a, int* b, double* c, int n);
extern void vecDivDoubleIntCPU(double* a, int* b, double* c, int n);
extern void vecDivIntDoubleCPU(int* a, double* b, double* c, int n); 
extern int vecSumInt(int* arr, int n);
extern double vecSumDouble(double* arr, int n);
extern bool check_error();
extern void copy_back(void* data, void*& d_data, int size);
extern void copy_front(void* data, void*& d_data, int size);
extern void g_alloc(void*& d_data, int size);
extern void just_return(void* data, void*& d_data, int size);
extern void just_front(void* data, void*& d_data, int size);
extern void dot_prodIntCPU(int* a, int* b, int* c, int ARows, int ACols, int BRows, int BCols, int CRows, int CCols);
extern void* spliceInt(int* arr1, int start, int stop);
extern void* spliceDouble(double* arr1, int star, int stop); 
extern void rangeSetInt(int* arr1, int* arr2, int start, int stop);
extern void rangeSetDouble(double* arr1, double* arr2, int start, int stop);
extern void dot_prodDoubleCPU(double* a, double* b, double* c, int ARows, int ACols, int BRows, int BCols, int CRows, int CCols);
extern void transposeInplaceIntCPU(int* srcDst, int width, int height);
extern void transposeInplaceDoubleCPU(double* srcDst, int width, int height);
extern void mulScalarIntDoubleCPU(int* a, int x, double* b, int n);
extern void mulScalarDoubleDoubleCPU(double* a, double x, double* b, int n);
extern void divScalarIntDoubleCPU(int* a, int x, double* b, int n);
extern void divScalarDoubleDoubleCPU(double* a, double x, double* b, int n);
extern void getSubMatrixDoubleCPU(double* a, double* b, int x1, int y1, int xd, int yd, int x, int y);
extern void getSubMatrixIntCPU(int* a, int* b, int x1, int y1, int xd, int yd, int x, int y);
extern void getInverseIntCPU(int* a, int* b, int n);
extern void getInverseDoubleCPU(double* a, double* b, int n);

extern int trensize;
#endif
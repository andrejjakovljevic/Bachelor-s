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
extern int vecSumInt(int* arr, int n);
extern double vecSumDouble(double* arr, int n);

#endif
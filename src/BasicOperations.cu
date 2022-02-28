#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "BasicOperations.h"

// Number of threads in each thread block
int blockSize = 1024;
 
__global__ void vecAddDoubleIntGPU(double *a, int *b, double *c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            c[id] = a[id] + b[id];
}

__global__ void vecMulDoubleIntGPU(double *a, int *b, double *c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            c[id] = a[id] * b[id];
}

__global__ void vecSubDoubleIntGPU(double *a, int *b, double *c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            c[id] = a[id] - b[id];
}

__global__ void vecSubIntDoubleGPU(int *a, double *b, double *c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            c[id] = a[id] - b[id];
}


__global__ void vecAddDoubleGPU(double *a, double *b, double *c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            c[id] = a[id] + b[id];
}

__global__ void vecAddIntGPU(int *a, int *b, int *c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            c[id] = a[id] + b[id];
}

__global__ void vecSubDoubleGPU(double *a, double *b, double *c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            c[id] = a[id] - b[id];
}

__global__ void vecSubIntGPU(int *a, int *b, int *c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            c[id] = a[id] - b[id];
}

__global__ void vecMulDoubleGPU(double* a, double *b, double *c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
      
      if (id < n)
            c[id] = a[id] * b[id];
}

__global__ void vecMulIntGPU(int* a, int *b, int *c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
      
      if (id < n)
            c[id] = a[id] * b[id];
}

void vecAddDoubleCPU(double *a, double *b, double *c, int n)
{
      double *d_a;
      double *d_b;
      double *d_c;
      int bytes = sizeof(double)*n;
      cudaMalloc(&d_a, bytes);
      cudaMalloc(&d_b, bytes);
      cudaMalloc(&d_c, bytes);
      cudaMemcpy( d_a, a, bytes, cudaMemcpyHostToDevice);
      cudaMemcpy( d_b, b, bytes, cudaMemcpyHostToDevice);

      int gridSize = (int)ceil((float)n/blockSize);
      vecAddDoubleGPU<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);
      cudaMemcpy( c, d_c, bytes, cudaMemcpyDeviceToHost );
      cudaFree(d_a);
      cudaFree(d_b);
      cudaFree(d_c);
}

void vecSubDoubleCPU(double *a, double *b, double *c, int n)
{
      double *d_a;
      double *d_b;
      double *d_c;
      int bytes = sizeof(double)*n;
      cudaMalloc(&d_a, bytes);
      cudaMalloc(&d_b, bytes);
      cudaMalloc(&d_c, bytes);
      cudaMemcpy( d_a, a, bytes, cudaMemcpyHostToDevice);
      cudaMemcpy( d_b, b, bytes, cudaMemcpyHostToDevice);
      int gridSize = (int)ceil((float)n/blockSize);
      vecSubDoubleGPU<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);
      cudaMemcpy( c, d_c, bytes, cudaMemcpyDeviceToHost );
      cudaFree(d_a);
      cudaFree(d_b);
      cudaFree(d_c);
}

void vecMulDoubleCPU(double *a, double *b, double *c, int n)
{
      double *d_a;
      double *d_b;
      double *d_c;
      int bytes = sizeof(double)*n;
      cudaMalloc(&d_a, bytes);
      cudaMalloc(&d_b, bytes);
      cudaMalloc(&d_c, bytes);
      cudaMemcpy( d_a, a, bytes, cudaMemcpyHostToDevice);
      cudaMemcpy( d_b, b, bytes, cudaMemcpyHostToDevice);
      int gridSize = (int)ceil((float)n/blockSize);
      vecMulDoubleGPU<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);
      cudaMemcpy( c, d_c, bytes, cudaMemcpyDeviceToHost );
      cudaFree(d_a);
      cudaFree(d_b);
      cudaFree(d_c);
}

void vecAddIntCPU(int *a, int *b, int *c, int n)
{
      int *d_a;
      int *d_b;
      int *d_c;
      int bytes = sizeof(int)*n;
      cudaMalloc(&d_a, bytes);
      cudaMalloc(&d_b, bytes);
      cudaMalloc(&d_c, bytes);
      cudaMemcpy( d_a, a, bytes, cudaMemcpyHostToDevice);
      cudaMemcpy( d_b, b, bytes, cudaMemcpyHostToDevice);
      int gridSize = (int)ceil((float)n/blockSize);
      vecAddIntGPU<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);
      cudaMemcpy( c, d_c, bytes, cudaMemcpyDeviceToHost );
      cudaFree(d_a);
      cudaFree(d_b);
      cudaFree(d_c);
}

void vecSubIntCPU(int *a, int *b, int *c, int n)
{
      int *d_a;
      int *d_b;
      int *d_c;
      int bytes = sizeof(int)*n;
      cudaMalloc(&d_a, bytes);
      cudaMalloc(&d_b, bytes);
      cudaMalloc(&d_c, bytes);
      cudaMemcpy( d_a, a, bytes, cudaMemcpyHostToDevice);
      cudaMemcpy( d_b, b, bytes, cudaMemcpyHostToDevice);
      int gridSize = (int)ceil((float)n/blockSize);
      vecSubIntGPU<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);
      cudaMemcpy( c, d_c, bytes, cudaMemcpyDeviceToHost );
      cudaFree(d_a);
      cudaFree(d_b);
      cudaFree(d_c);
}

void vecMulIntCPU(int *a, int *b, int *c, int n)
{
      int *d_a;
      int *d_b;
      int *d_c;
      int bytes = sizeof(int)*n;
      cudaMalloc(&d_a, bytes);
      cudaMalloc(&d_b, bytes);
      cudaMalloc(&d_c, bytes);
      cudaMemcpy( d_a, a, bytes, cudaMemcpyHostToDevice);
      cudaMemcpy( d_b, b, bytes, cudaMemcpyHostToDevice);
      int gridSize = (int)ceil((float)n/blockSize);
      vecMulIntGPU<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);
      cudaMemcpy( c, d_c, bytes, cudaMemcpyDeviceToHost );
      cudaFree(d_a);
      cudaFree(d_b);
      cudaFree(d_c);
}

void vecAddDoubleIntCPU(double *a, int *b, double *c, int n)
{
      double *d_a;
      int *d_b;
      double *d_c;
      int bytes1 = sizeof(int)*n;
      int bytes2 = sizeof(double)*n;
      cudaMalloc(&d_a, bytes2);
      cudaMalloc(&d_b, bytes1);
      cudaMalloc(&d_c, bytes2);
      cudaMemcpy( d_a, a, bytes2, cudaMemcpyHostToDevice);
      cudaMemcpy( d_b, b, bytes1, cudaMemcpyHostToDevice);
      int gridSize = (int)ceil((float)n/blockSize);
      vecAddDoubleIntGPU<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);
      cudaMemcpy( c, d_c, bytes2, cudaMemcpyDeviceToHost );
      cudaFree(d_a);
      cudaFree(d_b);
      cudaFree(d_c);
}

void vecMulDoubleIntCPU(double *a, int *b, double *c, int n)
{
      double *d_a;
      int *d_b;
      double *d_c;
      int bytes1 = sizeof(int)*n;
      int bytes2 = sizeof(double)*n;
      cudaMalloc(&d_a, bytes2);
      cudaMalloc(&d_b, bytes1);
      cudaMalloc(&d_c, bytes2);
      cudaMemcpy( d_a, a, bytes2, cudaMemcpyHostToDevice);
      cudaMemcpy( d_b, b, bytes1, cudaMemcpyHostToDevice);
      int gridSize = (int)ceil((float)n/blockSize);
      vecMulDoubleIntGPU<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);
      cudaMemcpy( c, d_c, bytes2, cudaMemcpyDeviceToHost );
      cudaFree(d_a);
      cudaFree(d_b);
      cudaFree(d_c);
}

void vecSubDoubleIntCPU(double *a, int *b, double *c, int n)
{
      double *d_a;
      int *d_b;
      double *d_c;
      int bytes1 = sizeof(int)*n;
      int bytes2 = sizeof(double)*n;
      cudaMalloc(&d_a, bytes2);
      cudaMalloc(&d_b, bytes1);
      cudaMalloc(&d_c, bytes2);
      cudaMemcpy( d_a, a, bytes2, cudaMemcpyHostToDevice);
      cudaMemcpy( d_b, b, bytes1, cudaMemcpyHostToDevice);
      int gridSize = (int)ceil((float)n/blockSize);
      vecSubDoubleIntGPU<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);
      cudaMemcpy( c, d_c, bytes2, cudaMemcpyDeviceToHost );
      cudaFree(d_a);
      cudaFree(d_b);
      cudaFree(d_c);
}

void vecSubIntDoubleCPU(int *a, double *b, double *c, int n)
{
      int *d_a;
      double *d_b;
      double *d_c;
      int bytes1 = sizeof(int)*n;
      int bytes2 = sizeof(double)*n;
      cudaMalloc(&d_a, bytes1);
      cudaMalloc(&d_b, bytes2);
      cudaMalloc(&d_c, bytes2);
      cudaMemcpy( d_a, a, bytes1, cudaMemcpyHostToDevice);
      cudaMemcpy( d_b, b, bytes2, cudaMemcpyHostToDevice);
      int gridSize = (int)ceil((float)n/blockSize);
      vecSubIntDoubleGPU<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);
      cudaMemcpy( c, d_c, bytes2, cudaMemcpyDeviceToHost );
      cudaFree(d_a);
      cudaFree(d_b);
      cudaFree(d_c);
}

void initVecIntCPU(int *a, int x, int n)
{
      for (int i=0;i<n;i++)
      {
            a[i]=x;
      }
}

extern void initVecDoubleCPU(double* a, double x, int n)
{
      for (int i=0;i<n;i++)
      {
            a[i]=x;
      }
}

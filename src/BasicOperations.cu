#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
#include "BasicOperations.h"
using namespace std;

// Number of threads in each thread block
static const int blockSize = 1024;
 
__global__ void vecAddDoubleIntGPU(double *a, int *b, double *c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            c[id] = a[id] + (double)b[id];
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

void initVecDoubleCPU(double* a, double x, int n)
{
      for (int i=0;i<n;i++)
      {
            a[i]=x;
      }
}

__global__ void sumCommMultiBlockInt(const int *gArr, int n, int *gOut) 
{
      int thIdx = threadIdx.x;
      int gthIdx = thIdx + blockIdx.x*blockSize;
      const int gridSize = blockSize*gridDim.x;
      int sum = 0;
      for (int i = gthIdx; i < n; i += gridSize)
            sum += gArr[i];
      __shared__ int shArr[blockSize];
      shArr[thIdx] = sum;
      __syncthreads();
      for (int size = blockSize/2; size>0; size/=2) { //uniform
            if (thIdx<size)
                  shArr[thIdx] += shArr[thIdx+size];
            __syncthreads();
      }
      if (thIdx == 0)
            gOut[blockIdx.x] = shArr[0];
}

__global__ void sumCommMultiBlockDouble(const double *gArr, int n, double *gOut) 
{
      int thIdx = threadIdx.x;
      int gthIdx = thIdx + blockIdx.x*blockSize;
      const int gridSize = blockSize*gridDim.x;
      double sum = 0;
      for (int i = gthIdx; i < n; i += gridSize)
            sum += gArr[i];
      __shared__ double shArr[blockSize];
      shArr[thIdx] = sum;
      __syncthreads();
      for (int size = blockSize/2; size>0; size/=2) { //uniform
            if (thIdx<size)
                  shArr[thIdx] += shArr[thIdx+size];
            __syncthreads();
      }
      if (thIdx == 0)
            gOut[blockIdx.x] = shArr[0];
}

int vecSumInt(int* arr, int n) 
{
      int* dev_arr;
      int gridSize = (int)ceil((float)n/blockSize);
      cudaMalloc(&dev_arr, n * sizeof(int));
      cudaMemcpy(dev_arr, arr, n * sizeof(int), cudaMemcpyHostToDevice);

      int out;
      int* dev_out;
      cudaMalloc(&dev_out, sizeof(int)*gridSize);

      sumCommMultiBlockInt<<<gridSize, blockSize>>>(dev_arr, n, dev_out);
      sumCommMultiBlockInt<<<1, blockSize>>>(dev_out, gridSize, dev_out);
      cudaDeviceSynchronize();

      cudaMemcpy(&out, dev_out, sizeof(int), cudaMemcpyDeviceToHost);
      cudaFree(dev_arr);
      cudaFree(dev_out);
      return out;
}

double vecSumDouble(double* arr, int n) 
{
      double* dev_arr;
      int gridSize = (int)ceil((float)n/blockSize);
      cudaMalloc(&dev_arr, n * sizeof(double));
      cudaMemcpy(dev_arr, arr, n * sizeof(double), cudaMemcpyHostToDevice);

      double out;
      double* dev_out;
      cudaMalloc(&dev_out, sizeof(double)*gridSize);

      sumCommMultiBlockDouble<<<gridSize, blockSize>>>(dev_arr, n, dev_out);
      sumCommMultiBlockDouble<<<1, blockSize>>>(dev_out, gridSize, dev_out);
      cudaDeviceSynchronize();

      cudaMemcpy(&out, dev_out, sizeof(double), cudaMemcpyDeviceToHost);
      cudaFree(dev_arr);
      cudaFree(dev_out);
      return out;
}
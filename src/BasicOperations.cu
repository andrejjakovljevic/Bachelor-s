#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
#include "BasicOperations.h"
using namespace std;

// Number of threads in each thread block
static const int blockSize = 1024;
static const int BLOCK_SIZE = 32;
//static const long long max_size = (long long)3*1024*1024*1024;
int trensize = 0;


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
      int gridSize = (int)ceil((float)n/blockSize);
      vecAddDoubleGPU<<<gridSize, blockSize>>>(a, b, c, n);
}

void vecSubDoubleCPU(double *a, double *b, double *c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecSubDoubleGPU<<<gridSize, blockSize>>>(a, b, c, n);
}

void vecMulDoubleCPU(double *a, double *b, double *c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecMulDoubleGPU<<<gridSize, blockSize>>>(a, b, c, n);
}

void vecAddIntCPU(int *a, int *b, int *c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecAddIntGPU<<<gridSize, blockSize>>>(a, b, c, n);
}

void vecSubIntCPU(int *a, int *b, int *c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecSubIntGPU<<<gridSize, blockSize>>>(a, b, c, n);
}

void vecMulIntCPU(int *a, int *b, int *c, int n)
{
     // int *d_a;
      //int *d_b;
      //int *d_c;
      //int bytes = sizeof(int)*n;
      //float time;
      //cudaMalloc(&d_a, bytes);
      //cudaMalloc(&d_b, bytes);
      //cudaMalloc(&d_c, bytes);
      //cudaMemcpy( d_a, a, bytes, cudaMemcpyHostToDevice);
      //cudaMemcpy( d_b, b, bytes, cudaMemcpyHostToDevice);
      int gridSize = (int)ceil((float)n/blockSize);

      /*cudaEvent_t start, stop;
      cudaEventCreate(&start);
      cudaEventCreate(&stop); 
      cudaEventRecord(start, 0);
*/
      vecMulIntGPU<<<gridSize, blockSize>>>(a, b, c, n);

      //cudaMemcpy( c, d_c, bytes, cudaMemcpyDeviceToHost );
      /*cudaEventRecord(stop, 0);
      cudaEventSynchronize(stop);
      cudaEventElapsedTime(&time, start, stop);*/
      //cudaFree(d_a);
      //cudaFree(d_b);
      //cudaFree(d_c);
      //printf("Time to generate:  %3.1f ms \n", time);
}

void vecAddDoubleIntCPU(double *a, int *b, double *c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecAddDoubleIntGPU<<<gridSize, blockSize>>>(a, b, c, n);
}

void vecMulDoubleIntCPU(double *a, int *b, double *c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecMulDoubleIntGPU<<<gridSize, blockSize>>>(a, b, c, n);
}

void vecSubDoubleIntCPU(double *a, int *b, double *c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecSubDoubleIntGPU<<<gridSize, blockSize>>>(a, b, c, n);
}

void vecSubIntDoubleCPU(int *a, double *b, double *c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecSubIntDoubleGPU<<<gridSize, blockSize>>>(a, b, c, n);
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

__global__ void dotIntGPU(int* d_a, int* d_b, int* d_c, int n) 
{
      __shared__ int tile_a[BLOCK_SIZE][BLOCK_SIZE];
      __shared__ int tile_b[BLOCK_SIZE][BLOCK_SIZE];

      int row = blockIdx.y * BLOCK_SIZE + threadIdx.y;
      int col = blockIdx.x * BLOCK_SIZE + threadIdx.x;
      int tmp = 0;
      int idx;

      for (int sub = 0; sub < gridDim.x; ++sub) 
      {
            idx = row * n + sub * BLOCK_SIZE + threadIdx.x;
            if(idx >= n*n)
            {
                  tile_a[threadIdx.y][threadIdx.x] = 0;
            }
            else
            {
                  tile_a[threadIdx.y][threadIdx.x] = d_a[idx];
            }

            idx = (sub * BLOCK_SIZE + threadIdx.y) * n + col;
            if(idx >= n*n)
            {
                  tile_b[threadIdx.y][threadIdx.x] = 0;
            }  
            else
            {
                  tile_b[threadIdx.y][threadIdx.x] = d_b[idx];
            }
            __syncthreads();

            for (int k = 0; k < BLOCK_SIZE; ++k) 
            {
                  tmp += tile_a[threadIdx.y][k] * tile_b[k][threadIdx.x];
            }
            __syncthreads();
      }
      if(row < n && col < n)
      {
            d_c[row * n + col] = tmp;
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
      for (int size = blockSize/2; size>0; size/=2) 
      { //uniform
            if (thIdx<size)
                  shArr[thIdx] += shArr[thIdx+size];
            __syncthreads();
      }
      if (thIdx == 0)
            gOut[blockIdx.x] = shArr[0];
}

int vecSumInt(int* dev_arr, int n) 
{
      int gridSize = (int)ceil((float)n/blockSize);

      int out;
      int* dev_out;
      cudaMalloc(&dev_out, sizeof(int)*gridSize);

      sumCommMultiBlockInt<<<gridSize, blockSize>>>(dev_arr, n, dev_out);
      sumCommMultiBlockInt<<<1, blockSize>>>(dev_out, gridSize, dev_out);
      cudaDeviceSynchronize();

      cudaMemcpy(&out, dev_out, sizeof(int), cudaMemcpyDeviceToHost);
      cudaFree(dev_out);
      return out;
}

double vecSumDouble(double* dev_arr, int n) 
{
      int gridSize = (int)ceil((float)n/blockSize);

      double out;
      double* dev_out;
      cudaMalloc(&dev_out, sizeof(double)*gridSize);

      sumCommMultiBlockDouble<<<gridSize, blockSize>>>(dev_arr, n, dev_out);
      sumCommMultiBlockDouble<<<1, blockSize>>>(dev_out, gridSize, dev_out);
      cudaDeviceSynchronize();

      cudaMemcpy(&out, dev_out, sizeof(double), cudaMemcpyDeviceToHost);
      cudaFree(dev_out);
      return out;
}

bool check_error()
{
      cudaError_t err = cudaGetLastError();  
      return ( err != cudaSuccess );
}

void copy_back(void* data, void*& d_data, int size)
{
      //cudaMemcpy(data, d_data, size, cudaMemcpyDeviceToHost);
      cudaFree(d_data);
      trensize-=size;
}

void copy_front(void* data, void*& d_data, int size)
{
      trensize+=size;
      cudaMalloc(&d_data, size);
      //cudaMemcpy(d_data, data, size, cudaMemcpyHostToDevice);
}

void g_alloc(void*& d_data, int size)
{
      cudaMalloc(&d_data, size);
}

void just_return(void* data, void*& d_data, int size)
{
      cudaMemcpy(data, d_data, size, cudaMemcpyDeviceToHost);
}

void just_front(void* data, void*& d_data, int size)
{
      cudaMemcpy(d_data, data, size, cudaMemcpyHostToDevice);
}

void dot_prodIntCPU(int* a, int* b, int* c, int n)
{
      dim3 Block_dim(BLOCK_SIZE, BLOCK_SIZE);
      int gridSize = (int)ceil((float)n/BLOCK_SIZE);
      dim3 Grid_dim(gridSize, gridSize);
      dotIntGPU << < Grid_dim, Block_dim >> > (a, b, c, n);
}

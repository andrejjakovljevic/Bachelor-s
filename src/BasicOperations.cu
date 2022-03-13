#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
#include "BasicOperations.h"
using namespace std;

// Number of threads in each thread block
static const int blockSize = 1024;
static const int TILE_DIM = 32;
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

__global__ void vecDivDoubleGPU(double* a, double* b, double* c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
      
      if (id < n)
            c[id] = a[id] / b[id];
}

__global__ void vecDivIntGPU(int* a, int* b, double* c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
      
      if (id < n)
            c[id] = (double)a[id] / (double)b[id];
}

__global__ void vecDivDoubleIntGPU(double* a, int* b, double* c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
      
      if (id < n)
            c[id] = a[id] / (double)b[id];
}

__global__ void vecDivIntDoubleGPU(int* a, double* b, double* c, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
      
      if (id < n)
            c[id] = (double)a[id] / b[id];
}

void vecDivDoubleCPU(double* a, double *b, double *c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecDivDoubleGPU<<<gridSize, blockSize>>>(a, b, c, n);      
}

void vecDivIntCPU(int* a, int* b, double* c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecDivIntGPU<<<gridSize, blockSize>>>(a, b, c, n);
}

void vecDivDoubleIntCPU(double* a, int* b, double* c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecDivDoubleIntGPU<<<gridSize, blockSize>>>(a, b, c, n);
}

void vecDivIntDoubleCPU(int* a, double* b, double* c, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      vecDivIntDoubleGPU<<<gridSize, blockSize>>>(a, b, c, n);
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



__global__ void dotIntGPU(int* A, int* B, int* C, int ARows, int ACols, int BRows,
      int BCols, int CRows, int CCols)
{
      int CValue = 0;

      int Row = blockIdx.y*TILE_DIM + threadIdx.y;
      int Col = blockIdx.x*TILE_DIM + threadIdx.x;

      __shared__ int As[TILE_DIM][TILE_DIM];
      __shared__ int Bs[TILE_DIM][TILE_DIM];

      for (int k = 0; k < (TILE_DIM + ACols - 1)/TILE_DIM; k++) {

            if (k*TILE_DIM + threadIdx.x < ACols && Row < ARows)
                  As[threadIdx.y][threadIdx.x] = A[Row*ACols + k*TILE_DIM + threadIdx.x];
            else
                  As[threadIdx.y][threadIdx.x] = 0.0;

            if (k*TILE_DIM + threadIdx.y < BRows && Col < BCols)
            {
                  Bs[threadIdx.y][threadIdx.x] = B[(k*TILE_DIM + threadIdx.y)*BCols + Col];
            }
            else
                  Bs[threadIdx.y][threadIdx.x] = 0.0;

            __syncthreads();

            for (int n = 0; n < TILE_DIM; ++n)
                  CValue += As[threadIdx.y][n] * Bs[n][threadIdx.x];

            __syncthreads();
      }

      if (Row < CRows && Col < CCols)
      {
            C[((blockIdx.y * blockDim.y + threadIdx.y)*CCols) +
                  (blockIdx.x * blockDim.x)+ threadIdx.x] = CValue;
      }
}

__global__ void dotDoubleGPU(double* A, double* B, double* C, int ARows, int ACols, int BRows,
      int BCols, int CRows, int CCols)
      {
            double CValue = 0;

            int Row = blockIdx.y*TILE_DIM + threadIdx.y;
            int Col = blockIdx.x*TILE_DIM + threadIdx.x;
      
            __shared__ double As[TILE_DIM][TILE_DIM];
            __shared__ double Bs[TILE_DIM][TILE_DIM];
      
            for (int k = 0; k < (TILE_DIM + ACols - 1)/TILE_DIM; k++) {
      
                  if (k*TILE_DIM + threadIdx.x < ACols && Row < ARows)
                        As[threadIdx.y][threadIdx.x] = A[Row*ACols + k*TILE_DIM + threadIdx.x];
                  else
                        As[threadIdx.y][threadIdx.x] = 0.0;
      
                  if (k*TILE_DIM + threadIdx.y < BRows && Col < BCols)
                  {
                        Bs[threadIdx.y][threadIdx.x] = B[(k*TILE_DIM + threadIdx.y)*BCols + Col];
                  }
                  else
                        Bs[threadIdx.y][threadIdx.x] = 0.0;
      
                  __syncthreads();
      
                  for (int n = 0; n < TILE_DIM; ++n)
                        CValue += As[threadIdx.y][n] * Bs[n][threadIdx.x];
      
                  __syncthreads();
            }
      
            if (Row < CRows && Col < CCols)
            {
                  C[((blockIdx.y * blockDim.y + threadIdx.y)*CCols) +
                        (blockIdx.x * blockDim.x)+ threadIdx.x] = CValue;
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
      //printf("CUDA Error: %s\n", cudaGetErrorString(err));  
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

void dot_prodIntCPU(int* a, int* b, int* c, int ARows, int ACols, int BRows, int BCols, int CRows, int CCols)
{
      dim3 Block_dim(TILE_DIM, TILE_DIM);
      int gridSizeWidth1 = (int)ceil((float)BCols/TILE_DIM);
      int gridSizeWidth2 = (int)ceil((float)ARows/TILE_DIM);
      dim3 Grid_dim(gridSizeWidth1, gridSizeWidth2);
      dotIntGPU << < Grid_dim, Block_dim >> > (a, b, c, ARows, ACols, BRows, BCols, CRows, CCols);
}

void dot_prodDoubleCPU(double* a, double* b, double* c, int ARows, int ACols, int BRows, int BCols, int CRows, int CCols)
{
      dim3 Block_dim(TILE_DIM, TILE_DIM);
      int gridSizeWidth1 = (int)ceil((float)BCols/TILE_DIM);
      int gridSizeWidth2 = (int)ceil((float)ARows/TILE_DIM);
      dim3 Grid_dim(gridSizeWidth1, gridSizeWidth2);
      dotDoubleGPU << < Grid_dim, Block_dim >> > (a, b, c, ARows, ACols, BRows, BCols, CRows, CCols);
}

__global__ void spliceIntGPU(int* a, int* b, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
      {
            a[id]=b[id];
      }
}

__global__ void spliceDoubleGPU(double* a, double* b, int n )
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            a[id]=b[id];
}

void* spliceInt(int* arr1, int start, int stop)
{
      void* d;
      int n = stop-start;
      int size = sizeof(int)*(stop-start);
      cudaMalloc(&d, size);
      int gridSize = (int)ceil((float)n/blockSize);
      spliceIntGPU<<<gridSize, blockSize>>>((int*)d, arr1+start, n);
      return d;
}

void* spliceDouble(double* arr1, int start, int stop)
{
      void* d;
      int n = stop-start;
      int size = sizeof(double)*(stop-start);
      cudaMalloc(&d, size);
      int gridSize = (int)ceil((float)n/blockSize);
      spliceDoubleGPU<<<gridSize, blockSize>>>((double*)d, arr1+start, n);
      return d;
}

void rangeSetInt(int* arr1, int* arr2, int start, int stop)
{
      int n = stop-start;
      int gridSize = (int)ceil((float)n/blockSize);
      spliceIntGPU<<<gridSize, blockSize>>>(arr1+start, arr2, n);
}

void rangeSetDouble(double* arr1, double* arr2, int start, int stop)
{
      int n = stop-start;
      int gridSize = (int)ceil((float)n/blockSize);
      spliceDoubleGPU<<<gridSize, blockSize>>>(arr1+start, arr2, n);
}

__global__ void transposeInplaceIntGPU(int* srcDst, int width, int pitch)
{
      int col = blockIdx.x * blockDim.x + threadIdx.x;
      int row = blockIdx.y * blockDim.y + threadIdx.y;

      int tid_in = row * pitch + col;
      int tid_out = col * pitch + row;

      if((row < width) && (col < width) && (row<col)) 
      {
            int temp = srcDst[tid_out];
            srcDst[tid_out] = srcDst[tid_in];
            srcDst[tid_in] = temp;
      }
} 

__global__ void transposeInplaceDoubleGPU(double* srcDst, int width, int pitch)
{
      int col = blockIdx.x * blockDim.x + threadIdx.x;
      int row = blockIdx.y * blockDim.y + threadIdx.y;

      int tid_in = row * pitch + col;
      int tid_out = col * pitch + row;

      if((row < width) && (col < width) && (row<col)) 
      {
            double temp = srcDst[tid_out];
            srcDst[tid_out] = srcDst[tid_in];
            srcDst[tid_in] = temp;
      }
} 

void transposeInplaceIntCPU(int* srcDst, int width, int height)
{
      dim3 Block_dim(TILE_DIM, TILE_DIM);
      int gridSizeWidth1 = (int)ceil((float)width/TILE_DIM);
      int gridSizeWidth2 = (int)ceil((float)height/TILE_DIM);
      dim3 Grid_dim(gridSizeWidth1, gridSizeWidth2);
      transposeInplaceIntGPU << < Grid_dim, Block_dim >> > (srcDst, width, height);
}

void transposeInplaceDoubleCPU(double* srcDst, int width, int height)
{
      dim3 Block_dim(TILE_DIM, TILE_DIM);
      int gridSizeWidth1 = (int)ceil((float)width/TILE_DIM);
      int gridSizeWidth2 = (int)ceil((float)height/TILE_DIM);
      dim3 Grid_dim(gridSizeWidth1, gridSizeWidth2);
      transposeInplaceDoubleGPU << < Grid_dim, Block_dim >> > (srcDst, width, height);
}

__global__ void mulScalarIntDoubleGPU(int* a, int x, double* b, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            b[id] = (double)a[id]*(double)x;
}

__global__ void divScalarIntDoubleGPU(int* a, int x, double* b, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            b[id] = (double)a[id]/(double)x;
}

__global__ void mulScalarDoubleDoubleGPU(double* a, double x, double* b, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            b[id] = (double)a[id]*(double)x;
}

__global__ void divScalarDoubleDoubleGPU(double* a, double x, double* b, int n)
{
      int id = blockIdx.x*blockDim.x+threadIdx.x;
 
      if (id < n)
            b[id] = (double)a[id]/(double)x;
}

void mulScalarIntDoubleCPU(int* a, int x, double* b, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      mulScalarIntDoubleGPU<<<gridSize, blockSize>>>(a, x, b, n);
}

void divScalarIntDoubleCPU(int* a, int x, double* b, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      divScalarIntDoubleGPU<<<gridSize, blockSize>>>(a, x, b, n);
}


void mulScalarDoubleDoubleCPU(double* a, double x, double* b, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      mulScalarDoubleDoubleGPU<<<gridSize, blockSize>>>(a, x, b, n);
}

void divScalarDoubleDoubleCPU(double* a, double x, double* b, int n)
{
      int gridSize = (int)ceil((float)n/blockSize);
      divScalarDoubleDoubleGPU<<<gridSize, blockSize>>>(a, x, b, n);
}

__global__ void getSubMatrixDoubleGPU(double* a, double* b, int x1, int y1, int xd, int yd, int x, int y)
{
      int y_moj = blockIdx.y*TILE_DIM + threadIdx.y;
      int x_moj = blockIdx.x*TILE_DIM + threadIdx.x;
      if (y_moj<yd && x_moj<xd)
      {
            b[y_moj*xd+x_moj]=a[(y_moj+y1)*x+x_moj+x1];
      }
}

__global__ void getSubMatrixIntGPU(int* a, int* b, int x1, int y1, int xd, int yd, int x, int y)
{
      int y_moj = blockIdx.y*TILE_DIM + threadIdx.y;
      int x_moj = blockIdx.x*TILE_DIM + threadIdx.x;
      if (y_moj<yd && x_moj<xd)
      {
            b[y_moj*xd+x_moj]=a[(y_moj+y1)*x+x_moj+x1];
      }
}

void getSubMatrixDoubleCPU(double* a, double* b, int x1, int y1, int xd, int yd, int x, int y)
{
      dim3 Block_dim(TILE_DIM, TILE_DIM);
      int gridSizeWidth1 = (int)ceil((float)xd/TILE_DIM);
      int gridSizeWidth2 = (int)ceil((float)yd/TILE_DIM);
      dim3 Grid_dim(gridSizeWidth1, gridSizeWidth2);
      getSubMatrixDoubleGPU << < Grid_dim, Block_dim >> > (a, b, x1, y1, xd, yd, x, y);
}

void getSubMatrixIntCPU(int* a, int* b, int x1, int y1, int xd, int yd, int x, int y)
{
      dim3 Block_dim(TILE_DIM, TILE_DIM);
      int gridSizeWidth1 = (int)ceil((float)xd/TILE_DIM);
      int gridSizeWidth2 = (int)ceil((float)yd/TILE_DIM);
      dim3 Grid_dim(gridSizeWidth1, gridSizeWidth2);
      getSubMatrixIntGPU << < Grid_dim, Block_dim >> > (a, b, x1, y1, xd, yd, x, y);
}
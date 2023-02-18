#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include <stdio.h>
#include <cstdlib>
#include <cassert>
#include <iostream>


using namespace std;


__global__ void matrixMul(int *a, int *b, int *c, int N)
{
       int row = blockIdx.y * blockDim.y + threadIdx.y;
       int col = blockIdx.x * blockDim.x + threadIdx.x;

       if(row < N && col < N)
       {

            int tmp = 0;

            for(int i = 0; i < N; i++)
            {
                   tmp += a[row * N + i] * b[i * N + col];
            }

              c[row * N + col] = tmp;

       }


}

void init_matrix(int *m, int N)
{
    for(int i = 0; i < N * N; i++)
    {
        m[i] = rand() % 100;

    }
}

void verify_result(int *a, int *b, int *c, int N)
{
   int tmp;

   for(int i = 0; i < N; i++)
   {
       for(int j = 0; j < N; j++)
       {
            tmp = 0;
          for(int k = 0; k < N; k++)
          {
              tmp += a[i * N + k] * b[k * N +j];
          }

          assert(tmp == c[i * N +j]);
       }
   }
}

int main()
{

   int N = 1 << 10;

   size_t bytes = N * N * sizeof(int);

    int *a,  *b,  *c;

    cudaMallocManaged(&a, bytes);
    cudaMallocManaged(&b, bytes);
    cudaMallocManaged(&c, bytes);

    init_matrix(a, N);
    init_matrix(b, N);


    int threads = 16;
    int blocks = (N + threads - 1) / threads;


    dim3 THREADS(threads,threads);
    dim3 BLOCKS(blocks, blocks);



 matrixMul<<<BLOCKS,THREADS >>>(a, b, c, N);


    cudaDeviceSynchronize();
    cudaDeviceReset();



    //verify_result(a, b, c, N);


  printf("Program success");



  return 0;
}

#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <time.h>

__global__ void mem_trs_test(int * input)
{
     int gid = blockIdx.x * blockDim.x + threadIdx.x;

     printf("tid : %d, gid : %d, value : %d \n",threadIdx.x, gid, input[gid]);
}

int main()
{

   int size = 128;
   int byte_size = size * sizeof(int);

   int * h_input;

   h_input = (int*) malloc(byte_size);

   time t;

   srand((unsigned)time(&t));

   for(int i = 0; i < size; i++)
   {
      h_input[i] = (int)(rand() & 0xff);
   }


   int * d_input;

  cudaMalloc((void**)&d_input,byte_size);

  cudaMemcpy(d_input, h_input, byte_size, cudaMemcpyHostToDevice);



   cudaDeviceReset();
  return 0;
}

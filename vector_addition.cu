#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include <stdio.h>
#include <cstdlib>
#include <cassert>
#include <iostream>
#include <assert.h>
#include <math.h>
#include <stdlib.h>
#include <algorithm>
#include <vector>


using namespace std;


__global__ void vectorAdd(const int  *a,const int *b, int *c, int N)
{
    int tid = (blockIdx.x * blockDim.x) + threadIdx.x;


    if(tid < N)
    {
        c[tid] = a[tid] + b[tid];
    }
}

void verify_result(vector<int> &a, vector<int> &b, vector<int> &c)
{
     for(int i = 0; i < a.size(); i++)
     {
         assert(c[i] == a[i] + b[i]);
     }
}


int main()
{
     constexpr int N = 1 << 16;

     constexpr size_t bytes =  sizeof(int) * N;


     vector<int> a;

     a.reserve(N);

     vector<int> b;

     b.reserve(N);

     vector<int> c;

     c.reserve(N);

     for(int i = 0; i < N; i++)
     {
         a.push_back(rand() % 100);
         b.push_back(rand() % 100);
     }
         int *d_a, *d_b, *d_c;

         cudaMalloc(&d_a, bytes);
          cudaMalloc(&d_b, bytes);
          cudaMalloc(&d_c, bytes);



          cudaMemcpy(d_a, a.data(), bytes, cudaMemcpyHostToDevice);
          cudaMemcpy(d_b, b.data(), bytes, cudaMemcpyHostToDevice);


          int NUM_THREADS = 1 << 10;

          int NUM_BLOCKS = (N + NUM_THREADS - 1 )/ NUM_THREADS;

         vectorAdd<<<NUM_BLOCKS, NUM_THREADS>>>(d_a, d_b, d_c,N);

         cudaMemcpy(c.data(), d_c, bytes, cudaMemcpyDeviceToHost);

         verify_result(a, b, c);

           cudaFree(d_a);
           cudaFree(d_b);
           cudaFree(d_c);

           cout << "Completed " << endl;

           cudaDeviceSynchronize();
           cudaDeviceReset();




     return 0;
 }

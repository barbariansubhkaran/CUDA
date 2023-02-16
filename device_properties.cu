#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include <stdio.h>

void query_device()
{
   int deviceCount = 0;

   cudaGetDeviceCount(&deviceCount);

   if(deviceCount == 0)
   {
       printf("No CUDA device found");
   }

   int devNo = 0;
   cudaDeviceProp iProp;

   cudaGetDeviceProperties(&iProp, devNo);

   printf("Device %d : %s\n", devNo, iProp.name);

   printf("Number of multiprocessors:               %d\n, iProp.multiprocessorCount");

   printf(" clock rate :                    %d\n, iProp.clockRate");

   printf(" Compute capability                 %d.%d\n", iProp.major, iProp.minor);


   printf(" Total amount of global memory :                  %4.2f KB\n", iProp.totalGlobalMem / 1024.0);

  printf(" Total amount of constant memory :               %4.2f  KB\n", iProp.sharedMemPerBlock / 1024.0);



}

int main()
{
       query_device();


  return 0;
}

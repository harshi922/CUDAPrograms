#include <stdio.h>
#include <cuda.h>
#define N 100
__global__ void dkernel(){
    printf("%d\n",threadIdx.x*threadIdx.x);
}

int main()
{
  dkernel<<<1,N>>>();
  cudaDeviceSynchronize();
  return 0;
}
#include <stdio.h>
#include <cuda.h>
#define N 100
__global__ void dkernel(int *a){
    a[threadIdx.x] = threadIdx.x*threadIdx.x;
}

int main()
{
  // da is GPU memory pointer
  int a[N], *da;
  cudaMalloc(&da, sizeof(int)*N);
  dkernel<<<1,N>>>(da);
  // copy memory from GPU (Device) to CPU (host) - dest, src
  cudaMemcpy(a,da,N*sizeof(int),cudaMemcpyDeviceToHost);
  for (int i=0;i<N;i++)
    printf("%d\t",a[i]);
  // cudaDeviceSynchronize();
  return 0;
}
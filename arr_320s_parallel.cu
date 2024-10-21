#include <stdio.h>
#include <cuda.h>

__global__ void init(int *a, int alen){
  unsigned id = threadIdx.x;
  if(id<alen)
  {
    a[id] = 0;
  }
}
__global__ void dkernel(int *a, int alen){
  unsigned id = threadIdx.x;
  if(id<alen)
  {
    a[id] += id;
  }
}


int main()
{
  int *da, N;
  N=1024;
  int a[N];
  cudaMalloc(&da,sizeof(int)*N);
  init<<<1,N>>>(da,N);
  dkernel<<<1,N>>>(da,N);
  cudaMemcpy(a,da,N*sizeof(int),cudaMemcpyDeviceToHost);
  for (int i=0;i<N;i++)
    printf("%d\t",a[i]);
  // cudaDeviceSynchronize();
  return 0;
}
#include <stdio.h>
#include <cuda.h>
#define N 5
#define M 6
__global__ void dkernel(unsigned *matrix){

  matrix[threadIdx.x+blockDim.x*blockIdx.x] = threadIdx.x+blockDim.x*blockIdx.x; 
  
}
int main() {
  unsigned *gpu_matrix, *device_matrix;
  cudaMalloc(&gpu_matrix, N*M*sizeof(unsigned));
  device_matrix = (unsigned *) malloc(N*M *sizeof(unsigned)); 
  dkernel<<<N,M>>>(gpu_matrix);
  cudaMemcpy(device_matrix, gpu_matrix, N*M*sizeof(unsigned), cudaMemcpyDeviceToHost);
  for(unsigned i =0; i<N;i++)
  {
    for(int j=0;j<M;j++)
    {
      printf("%2d", device_matrix[i*M+j]);
    }
    printf("\n");
  }
  cudaDeviceSynchronize();
  return 0;
}
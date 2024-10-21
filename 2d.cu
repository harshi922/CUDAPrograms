#include <stdio.h>
#include <cuda.h>
#define N 5
#define M 6
__global__ void dkernel(unsigned *matrix){
  i = threadIdx.x
  j = threadIdx.y

  matrix[threadIdx.x*blockDim.y+threadIdx.y] = threadIdx.x*blockDim.y+threadIdx.y 
  
}
int main() {
  dim3 block(N,M,1);
  unsigned *gpu_matrix, *device_matrix;
  cudaMalloc(&gpu_matrix, N*M*sizeof(unsigned));
  device_matrix = (unsigned *) malloc(N*M *sizeof(unsigned)) 
  dkernel<<<1,block>>>(device_matrix);
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
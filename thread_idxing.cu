#include <stdio.h>
#include <cuda.h>
__global__ void idxing(int *arr, int size)
{
  int gid = blockIdx.z * gridDim.x * gridDim.y * blockDim.x*blockDim.y*blockDim.z 
  + blockIdx.y * gridDim.x *  blockDim.x*blockDim.y*blockDim.z
  + blockIdx.x * blockDim.x*blockDim.y*blockDim.z
  + threadIdx.z * blockDim.x * blockDim.y
  + threadIdx.y * blockDim.x
  + threadIdx.x;
  if (gid<size)
  {
    printf("%d %d\n", gid,arr[gid]);
  } 

}

int main()
{
  int *h_arr,*d_arr;
  int size=64;
  h_arr = (int*)malloc(sizeof(int)*size);
  for(int i=0;i<size;i++)
  {
    h_arr[i] = i*100;
  }
  cudaMalloc(&d_arr,sizeof(int)*size);
  cudaMemcpy(d_arr,h_arr,sizeof(int)*size,cudaMemcpyHostToDevice);
  dim3 grid(4,4,4);
  dim3 block(2,2,2);
  idxing<<<grid, block>>>(d_arr,size);
  cudaDeviceSynchronize();
  return 0;
}
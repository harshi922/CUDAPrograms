#include <stdio.h>
#include <cuda.h>
__global__ void dkernel(unsigned *matrix, unsigned *res, unsigned size) {
  unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
  for(unsigned jj=0;jj<size;jj++)
  {
    for(unsigned kk=0;kk<size;kk++)
    {
      res[id * size + jj] += matrix[id * size + kk] * matrix[kk * size + jj];
    }
    // res[id * size + jj] = sum;
  }
}
#define N 3
int main() {
 unsigned *matrix, *hmatrix, *res, *hres;
 cudaMalloc(&matrix, N * N *sizeof(unsigned));
 cudaMalloc(&res, N * N *sizeof(unsigned));

 hmatrix = (unsigned *)malloc(N * N * sizeof(unsigned));
 hres = (unsigned *)malloc(N * N * sizeof(unsigned));

 for (unsigned ii = 0; ii < N; ++ii) {
    for(unsigned jj = 0; jj < N; ++jj)
    {
      hmatrix[ii *N + jj] = ii *N + jj;
      printf("%4d ", hmatrix[ii *N + jj]);
    }
 }  for (unsigned ii = 0; ii < N; ++ii) {
    for(unsigned jj = 0; jj < N; ++jj)
    {
      hres[ii *N + jj] = 0;
    }
 } 


 cudaMemcpy(matrix, hmatrix, N * N * sizeof(unsigned), cudaMemcpyHostToDevice);
 dkernel<<<1, N>>>(matrix, res, N);
 cudaMemcpy(hres, res, N * N * sizeof(unsigned), cudaMemcpyDeviceToHost);
 for (unsigned ii = 0; ii < N; ++ii) {
    for(unsigned jj = 0; jj < N; ++jj)
    {
      printf("%4d ", hres[ii *N + jj]);
    }
 }
 return 0;
}
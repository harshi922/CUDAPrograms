#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void dkernel(int *a, int *sq, int *cu, int alen){
  unsigned id = threadIdx.x;
  if(id<alen)
  {
    // printf("%d ", sq[id]);    printf("%d ", cu[id]);

    a[id] = (sq[id]*sq[id]) + (cu[id]*cu[id]*cu[id]);
  }
}


int main()
{

  FILE *cubed = fopen("ints.txt", "r");  
  FILE *squared = fopen("another_ints.txt", "r"); 
  if (cubed == NULL || squared == NULL) {
        printf("Unable to open the file\n");
        return 1;
    } 
    int sq, cu, i;
    int N = 10;
    int sq_arr[N], cu_arr[N],a[N];
    while ((fscanf(cubed, "%d", &cu) == 1) && (fscanf(squared, "%d", &sq) == 1)) {
        sq_arr[i] = sq;
        cu_arr[i] = cu;
        i+=1;
    }
  fclose(squared);
  fclose(cubed);
    
    int *da, *dsq_arr, *dcu_arr;
    cudaMalloc(&da, sizeof(int)*N);
    cudaMalloc(&dsq_arr, sizeof(int)*N);
    cudaMalloc(&dcu_arr, sizeof(int)*N);

    cudaMemcpy(dcu_arr,cu_arr,N*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dsq_arr,sq_arr,N*sizeof(int), cudaMemcpyHostToDevice);

    dkernel<<<1, N>>>(da,dsq_arr, dcu_arr, N);

    cudaMemcpy(a,da,N*sizeof(int), cudaMemcpyDeviceToHost);
  
    for(int i=0;i<N;i++)
    {
      printf("%d ", a[i]);
    }


  return 0;
}
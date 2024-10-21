#include <stdio.h>
#include <time.h>
#define N 64
void sq_cpu(int matrix[N][N], int res[N][N], int size)
{
  for(int i=0;i<N;i++)
  {
    for(int j=0;j<N;j++)
    {
      for(int k=0;k<N;k++)
      {
         res[i][j] += matrix[i][k] + matrix[k][j];
      }
    }
  }
}
int main()
{
  int m[N][N], res[N][N];
  for(int i=0;i<N;i++)
  {
    for(int j=0;j<N;j++)
    {
      m[i][j]= i*N + j;
    }
  }
  clock_t start = clock();
  sq_cpu(m,res, N);
  clock_t end = clock();
  double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC ;
  printf("Time taken: %f ms\\n", cpu_time_used/1000);

  for(int i=0;i<N;i++)
  {
    printf("\n");
    for(int j=0;j<N;j++)
    {
      printf("%d\t", res[i][j]);
    }
  }


  return 0;
}
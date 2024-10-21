#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>
#include <time.h>  // Include for timing

// Error checking macro
#define CUDA_ERROR_CHECK(call) {                       \
    cudaError_t err = call;                           \
    if (err != cudaSuccess) {                         \
        fprintf(stderr, "CUDA Error: %s\n", cudaGetErrorString(err)); \
        exit(1);                                      \
    }                                                 \
}
#define COMPARE_ARRAYS(h_a, h_b, h_c, h_res, size) {       \
    for (int i = 0; i < size; i++) {                  \
        if (h_res[i] != h_a[i] + h_b[i] + h_c[i]) {            \
            printf("Mismatch at index %d: %d + %d + %d != %d\n", \
                   i, h_a[i], h_b[i], h_c[i], h_res[i]);     \
            exit(1);                                   \
        }                                             \
    }                                                 \
    printf("Arrays match!\n");                         \
}

__global__ void dkernel(int *a, int *b, int *c, int *res, int size)
{
    int gid = threadIdx.x + blockDim.x * blockIdx.x;
    if(gid < size)
    {
        res[gid] = a[gid] + b[gid] + c[gid];
    } 
}

void addarrs(int *a, int *b, int *c, int *res, int size)
{
    for (int i = 0; i < size; i++)
    {
        res[i] = a[i] + b[i] + c[i];
    }
}

int main()
{
    int size = 1 << 22;  // Set size to 2^22
    int *h_a, *h_b, *h_c, *h_res, *d_a, *d_b, *d_c, *d_res;

    // Allocate host memory
    h_a = (int*)malloc(size * sizeof(int));
    h_b = (int*)malloc(size * sizeof(int));
    h_c = (int*)malloc(size * sizeof(int));
    h_res = (int*)malloc(size * sizeof(int));

    // Initialize host arrays
    for (int i = 0; i < size; i++) 
    {
        h_a[i] = rand() % 100;
        h_b[i] = rand() % 100;
        h_c[i] = rand() % 100;
    }
    memset(h_res, 0, size * sizeof(int));

    // Allocate device memory
    CUDA_ERROR_CHECK(cudaMalloc((void **)&d_a, size * sizeof(int)));
    CUDA_ERROR_CHECK(cudaMalloc((void **)&d_b, size * sizeof(int)));
    CUDA_ERROR_CHECK(cudaMalloc((void **)&d_c, size * sizeof(int)));
    CUDA_ERROR_CHECK(cudaMalloc((void **)&d_res, size * sizeof(int)));

    // Copy data from host to device
    CUDA_ERROR_CHECK(cudaMemcpy(d_a, h_a, size * sizeof(int), cudaMemcpyHostToDevice));
    CUDA_ERROR_CHECK(cudaMemcpy(d_b, h_b, size * sizeof(int), cudaMemcpyHostToDevice));
    CUDA_ERROR_CHECK(cudaMemcpy(d_c, h_c, size * sizeof(int), cudaMemcpyHostToDevice));

    // Define block sizes to test
    int block_sizes[] = { 64, 128, 256, 512 };
    
    // Loop over different block sizes
    for(int i = 0; i < 4; i++)
    {
        int block_size = block_sizes[i];
        int grid_size = (size + block_size - 1) / block_size; // Calculate grid size

        // Timing GPU execution
        clock_t start_gpu = clock(); // Start timing
        dkernel<<<grid_size, block_size>>>(d_a, d_b, d_c, d_res, size);
        CUDA_ERROR_CHECK(cudaDeviceSynchronize()); // Wait for GPU to finish
        clock_t end_gpu = clock(); // End timing
        double gpu_time = (double)(end_gpu - start_gpu) / CLOCKS_PER_SEC; // Calculate elapsed time

        // Copy result from device to host
        CUDA_ERROR_CHECK(cudaMemcpy(h_res, d_res, size * sizeof(int), cudaMemcpyDeviceToHost));

        // Timing CPU execution
        clock_t start_cpu = clock(); // Start timing
        addarrs(h_a, h_b, h_c, h_res, size);
        clock_t end_cpu = clock(); // End timing
        double cpu_time = (double)(end_cpu - start_cpu) / CLOCKS_PER_SEC; // Calculate elapsed time

        // Compare CPU and GPU results
        COMPARE_ARRAYS(h_a, h_b, h_c, h_res, size);

        // Print the timings
        printf("Block size: %d\n", block_size);
        printf("GPU execution time: %f seconds\n", gpu_time);
        printf("CPU execution time: %f seconds\n", cpu_time);
        printf("\n"); // Add a new line for better readability
    }

    // Free device memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    cudaFree(d_res);
    
    // Free host memory
    free(h_a);
    free(h_b);
    free(h_c);
    free(h_res);

    return 0;
}

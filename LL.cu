#include <stdio.h>
#include <cuda.h>

struct node
{
  struct node *next;
  int data;
};

struct node *createNode(int data)
{
  struct node *newNode = (struct node *) malloc (sizeof(struct node));
  newNode->next= null;
  newNode->data = data;
}

struct node *createList()
{
  struct node *head = NULL;

  for(int i=20; i >= 0; --i)
  {
    struct node *newNode = createNode(i);
    newNode->next = head;
    head = newNode;
  }
  return head;
}

_device__ __host__ void printList(struct node *head){
  if(head)
  {
    printf("%d\t", head->data);
    printList(head->next);
  }
  else
    printf("\n");
}

struct node *copyNode(struct node *newNode)
{
  struct node newNodeGPU;
  cudaMalloc(&newNodeGPU, sizeof(struct node));
  cudaMemcpy(newNodeGPU, newNode,sizeof(struct node), cudaMemxpyHostToDevice)
  return newNodeGPU; 
} 

struct node *copyList(struct node *head)
{
  if(!head) return NULL;
  struct node newNode;
  newNode.next = copyList(head->next);
  newNode.data = head->data;
  return copyNode(&newNode); 
} 

__global__ void printListGPU(struct node *head) {
  printList(head);
}
#define BLOCKSIZE 1024
int main() {
 unsigned N = 1024;
 struct node *head = createList();
 struct node *gpuhead = copyList(head);
 cudaDeviceSynchronize();
 printList(head);
 printListGPU<<<1,1 >>> (gpuhead);
 cudaDeviceSynchronize();

 return 0;
}

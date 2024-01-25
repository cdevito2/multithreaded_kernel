#include "memory.h"


// c is the value to be set
// ptr is the pointer to the block of memory to fill
// size is number of bytes to be set to the value of c
void* memset(void *ptr, int c, size_t size)
{
    char *c_ptr = (char *)ptr;

    //now its a char pointer to loop through n addresses and put c in it 

    for (int i=0;i<size;i++)
    {
        c_ptr[i] = (char )c;
    }


    //return pointer
    return ptr;
}
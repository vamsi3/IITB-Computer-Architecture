#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
//#include <intrin.h> /* for rdtscp and clflush */
#include <x86intrin.h> /* for rdtscp and clflush */


int main()
{

	int A[1024];
	int Access_Time[1024] = {0};
	int i,j, aux, access;	
	int *p;
	register uint64_t time1, time2;
	p=&A[0]; // p stores base address of array

	// Initialize array
	for(i=0;i<1024;i+=16)
	A[i]=i;


	//Measuring the time
	for (j=0; j<32;j++)
	{
		access = *(p+16);
		time1 = __rdtscp(&aux);
		access = *(p+16+j);
		time2 = __rdtscp(&aux) - time1;
		Access_Time[j]=time2;
		_mm_clflush((p+32));
	}

	for (int j=0; j<32;j++)
		printf("%d  -> %d\n",16+j, Access_Time[j]);

	return 0;
}
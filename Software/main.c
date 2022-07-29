#include <system.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alt_types.h>
#include<time.h>
#include "padding.h"

// struct padded input, hash read, Hvals, hard set start and hash read initially

int main()
{

    HASHING->HASHLOOP_DONE = 0x00000000;
    HASHING->START = 0x00000000;

    char str[100];
    printf("Enter string to be hashed\n");
    scanf("%s" , &str);



    int len = strlen(str);
    int x = len/4;
    int mod = len % 4;
    int blocks;
    alt_u32 temp;

    printf("String length: %d\n", len);
    printf("String: %s\n", str);

    if(len<56)
        blocks = 1;

    else if(len%64 < 56)
        blocks = len/64 + 1;

    else
        blocks = len/64 + 2;
    
    alt_u32 padding [16*blocks];
    

    for(int i = 0; i<16*blocks; i++)
    {
        padding[i] = 0x00000000;
    }

    for(int i=0; i < x; i++)
    {
        padding[i] = (alt_u32)str[4*i] << 24 | (alt_u32)str[4*i+1] << 16 | (alt_u32)str[4*i+2] << 8 | (alt_u32)str[4*i+3];
    }

    if(mod == 3)
    {
        padding[x] = (alt_u32)str[4*x] << 24 | (alt_u32)str[4*x+1] << 16 | (alt_u32)str[4*x+2] << 8 ;
        temp = padding[x] + (1 << 7);
        padding[x] = temp;
    }
    else if(mod == 2)
    {
        padding[x] = (alt_u32)str[4*x] << 24 | (alt_u32)str[4*x+1] << 16;
        temp = padding[x] + (1 << 15);
        padding[x] = temp;
    }
    else if (mod == 1)
    {
        padding[x] = (alt_u32)str[4*x] << 24 ;
        temp = padding[x] + (1 << 23);
        padding[x] = temp;
    }
    else{
        temp = padding[x] + (1 << 31);
        padding[x] = temp;
    }

    //alt_u64 bitLength = len * 8;
    //padding[16*(blocks-1)+14] = bitLength & 0xFFFFFFFF;
    padding[16*(blocks-1)+15] = len * 8;

    printf("\nPadded Input: \n");

    for(int i=0; i<16; i++){
    	printf("%x\n",padding[i]);
    }

//    printf("%x\n",HASHING->H[0]);
//    printf("%x\n",HASHING->H[1]);
//    printf("%x\n",HASHING->H[2]);
//    printf("%x\n",HASHING->H[3]);
//    printf("%x\n",HASHING->H[4]);
//    printf("%x\n",HASHING->H[5]);
//    printf("%x\n",HASHING->H[6]);
//    printf("%x\n",HASHING->H[7]);

    clock_t start = clock();

    HASHING->paddedBlock[0] = padding[0];
    HASHING->paddedBlock[1] = padding[1];
    HASHING->paddedBlock[2] = padding[2];
    HASHING->paddedBlock[3] = padding[3];
    HASHING->paddedBlock[4] = padding[4];
    HASHING->paddedBlock[5] = padding[5];
    HASHING->paddedBlock[6] = padding[6];
    HASHING->paddedBlock[7] = padding[7];
    HASHING->paddedBlock[8] = padding[8];
    HASHING->paddedBlock[9] = padding[9];
    HASHING->paddedBlock[10] = padding[10];
    HASHING->paddedBlock[11] = padding[11];
    HASHING->paddedBlock[12] = padding[12];
    HASHING->paddedBlock[13] = padding[13];
    HASHING->paddedBlock[14] = padding[14];
    HASHING->paddedBlock[15] = padding[15];
    HASHING->HASHLOOP_DONE = 0x00000000;
    HASHING->START = 0x00000001;


//        HASHING->paddedBlock[0] = 0x68656C6C;
//        HASHING->paddedBlock[1] = 0x6F20776F;
//        HASHING->paddedBlock[2] = 0x726C6480;
//        HASHING->paddedBlock[3] = 0x00000000;
//        HASHING->paddedBlock[4] = 0x00000000;
//        HASHING->paddedBlock[5] = 0x00000000;
//        HASHING->paddedBlock[6] = 0x00000000;
//        HASHING->paddedBlock[7] = 0x00000000;
//        HASHING->paddedBlock[8] = 0x00000000;
//        HASHING->paddedBlock[9] = 0x00000000;
//        HASHING->paddedBlock[10] = 0x00000000;
//        HASHING->paddedBlock[11] = 0x00000000;
//        HASHING->paddedBlock[12] = 0x00000000;
//        HASHING->paddedBlock[13] = 0x00000000;
//        HASHING->paddedBlock[14] = 0x00000000;
//        HASHING->paddedBlock[15] = 0x00000058;
//        HASHING->HASHLOOP_DONE = 0x00000000;
//        HASHING->START = 0x00000001;

//    usleep (500000);

    while(1)
    {
    	if(HASHING->HASHLOOP_DONE = 0x00000001)
    		break;
    	else
    		usleep(1);
    }

    clock_t end = clock();

    double time_taken = (double)(end - start);
    printf("\nHashed in %f Microseconds\n", time_taken);

    printf("\nHashed String: \n");
    printf("%x\n",HASHING->H[0]);
    printf("%x\n",HASHING->H[1]);
    printf("%x\n",HASHING->H[2]);
    printf("%x\n",HASHING->H[3]);
    printf("%x\n",HASHING->H[4]);
    printf("%x\n",HASHING->H[5]);
    printf("%x\n",HASHING->H[6]);
    printf("%x\n",HASHING->H[7]);






//    printf("%x\n",HASHING->HASHLOOP_DONE);
//    printf("%x\n",HASHING->START);


        
//        for(int i=0; i<blocks;i++)
//        {
//            HASHING->HASHLOOP_DONE = 0x00000000;
//
//            printf("%x", HASHING->HASHLOOP_DONE);
//
//            for(int j=0; j<16; j++)
//                HASHING->paddedBlock[j] = padding[(i)*16+j];
//
//            while(1){
//               if(HASHING->HASHLOOP_DONE == 0x00000001)
//                    break;
//            }
//
//        }
//
//        printf("The Hash is: \n");
//
//        for(int i = 0; i < 8; i++){
//
//            printf("%x",HASHING->H[i]);
//        }

        return 0;
    

}

// int main(){

//     //uint32_t paddedBlock[16];

    

//     //padding();

//     //int i = full_padding->

//     for()

//     while(1)
//     {
//         if(HASHING->HASHLOOP_DONE = 1)
//             break;
//     }
    
//     for(int i = 0; i < 8; i++){

//         printf(HASHING->H[i]);
//     }
    
//     //printf(paddedBlock[0]);

#include <system.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alt_types.h>
#include<time.h>
#include "cpuhash.h"

// uses https://github.com/EddieEldridge/SHA256-in-C/blob/master/SHA256.c reformatted to work on nios 2, with original padding method

int main()
{
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

    clock_t start = clock();

    alt_u32 K[] =
       {
           0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
           0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
           0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
           0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
           0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
           0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
           0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
           0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
           0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
           0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
           0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
           0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
           0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
           0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
           0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
           0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
       };

       alt_u32 H[8] = {
           0x6a09e667,
           0xbb67ae85,
           0x3c6ef372,
           0xa54ff53a,
           0x510e527f,
           0x9b05688c,
           0x1f83d9ab,
           0x5be0cd19
       };

    int j;
    alt_u32 W[64];

    for(j=0; j<16; j++)
    {
        W[j] = padding[j];
    }

    for (j=16; j<64; j++)
        {
            // Step 1
            W[j] = sig1(W[j-2]) + W[j-7] + sig0(W[j-15]) + W[j-16];
        }

    alt_u32 a, b, c, d, e, f, g, h;

    // Temp variables
    alt_u32 T1, T2;

    a=H[0];
    b=H[1];
    c=H[2];
    d=H[3];
    e=H[4];
    f=H[5];
    g=H[6];
    h=H[7];

    for(j = 0; j < 64; j++)
        {
            // Creating new variables
            T1 = h + SIG1(e) + Ch(e,f,g) + K[j] + W[j];
            T2 = SIG0(a) + Maj(a,b,c);
            h = g;
            g = f;
            f = e;
            e = d + T1;
            d = c;
            c = b;
            b = a;
            a = T1 + T2;
        }

    H[0] = a + H[0];
    H[1] = b + H[1];
    H[2] = c + H[2];
    H[3] = d + H[3];
    H[4] = e + H[4];
    H[5] = f + H[5];
    H[6] = g + H[6];
    H[7] = h + H[7];

    clock_t end = clock();

        double time_taken = (double)(end - start);
        printf("\nHashed in %f Microseconds\n", time_taken);

    printf("\nHashed String: \n");
    printf("%x\n",H[0]);
    printf("%x\n",H[1]);
    printf("%x\n",H[2]);
    printf("%x\n",H[3]);
    printf("%x\n",H[4]);
    printf("%x\n",H[5]);
    printf("%x\n",H[6]);
    printf("%x\n",H[7]);





        return 0;


}


alt_u32 sig0(alt_u32 x)
{
    // Section 3.2
	return (rotr(x, 7) ^ rotr(x, 18) ^ shr(x, 3));
};

alt_u32 sig1(alt_u32 x)
{
	return (rotr(x, 17) ^ rotr(x, 19) ^ shr(x, 10));
};

// Rotate bits right
alt_u32 rotr(alt_u32 x, alt_u16 a)
{
	return (x >> a) | (x << (32 - a));
};

// Shift bits right
alt_u32 shr(alt_u32 x, alt_u16 b)
{
	return (x >> b);
};

alt_u32 SIG0(alt_u32 x)
{
	return (rotr(x, 2) ^ rotr(x, 13) ^ rotr(x, 22));
};

alt_u32 SIG1(alt_u32 x)
{
	return (rotr(x, 6) ^ rotr(x, 11) ^ rotr(x, 25));
};

// Choose
alt_u32 Ch(alt_u32 x,alt_u32 y,alt_u32 z)
{
	return ((x & y) ^ (~(x)&z));
};

// Majority decision
alt_u32 Maj(alt_u32 x,alt_u32 y,alt_u32 z)
{
	return ((x & y) ^ (x & z) ^ (y & z));
};

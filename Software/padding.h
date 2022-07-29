#ifndef PADDING_H
#define PADDING_H 

#include <system.h>
#include <alt_types.h>

struct HASH_STRUCT {
	
	alt_u32 paddedBlock[16];
	alt_u32 HASHLOOP_DONE;
	alt_u32 H[8];
	alt_u32 START;

};

static volatile struct HASH_STRUCT* HASHING = SHA256_ACCELERATOR_0_BASE;

#endif

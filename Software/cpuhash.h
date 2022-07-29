#ifndef PADDING_H
#define PADDING_H 

#include <system.h>
#include <alt_types.h>

alt_u32 sig0(alt_u32 x);
alt_u32 sig1(alt_u32 x);

alt_u32 rotr(alt_u32 n, alt_u16 x);
alt_u32 shr(alt_u32 n, alt_u16 x);

alt_u32 SIG0(alt_u32 x);
alt_u32 SIG1(alt_u32 x);

alt_u32 Ch(alt_u32 x,alt_u32 y,alt_u32 z);
alt_u32 Maj(alt_u32 x,alt_u32 y,alt_u32 z);

#endif

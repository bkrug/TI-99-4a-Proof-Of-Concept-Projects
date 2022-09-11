       DEF  BEETHV

       COPY 'NOTEVAL.asm'
       COPY 'CONST.asm'

*
* Song Header
*
BEETHV DATA BEET1,BEET2,BEET3
* Duration ratio in 60hz environment
       DATA 2,1
* Duration ratio in 50hz environment
       DATA 10,6

BEET1
* 3/8
       BYTE E3,N16
       BYTE Ds3,N16
*
       BYTE E3,N16
       BYTE Ds3,N16
       BYTE E3,N16
       BYTE B2,N16
       BYTE D3,N16
       BYTE C3,N16
*
       BYTE A2,N8
       BYTE REST,N16
       BYTE C2,N16
       BYTE E2,N16
       BYTE A2,N16
*
       BYTE B2,N8
       BYTE REST,N16
       BYTE E2,N16
       BYTE Gs2,N16
       BYTE B2,N16
*
       BYTE C3,N8
       BYTE REST,N16
       BYTE E2,N16
       BYTE E3,N16
       BYTE Ds3,N16
*
       BYTE E3,N16
       BYTE Ds3,N16
       BYTE E3,N16
       BYTE B2,N16
       BYTE D3,N16
       BYTE C3,N16
*
       BYTE A2,N8
       BYTE REST,N16
       BYTE C2,N16
       BYTE E2,N16
       BYTE A2,N16
* Measure 7
       BYTE B2,N8
       BYTE REST,N16
       BYTE D2,N16
       BYTE C3,N16
       BYTE B2,N16
*
       BYTE A2,N4
*
       DATA REPEAT,BEET1

BEET2
* 3/8
       DATA STOP,0

BEET3
* 3/8
       BYTE REST,N8
*
       BYTE REST,N8*3
*
       BYTE A0,N16
       BYTE E1,N16
       BYTE A1,N16
       BYTE REST,N8DOT
*
       BYTE B0,N16
       BYTE E1,N16
       BYTE Gs1,N16
       BYTE REST,N8DOT
*
       BYTE A0,N16
       BYTE E1,N16
       BYTE A1,N16
       BYTE REST,N8DOT
*
       BYTE REST,N8*3
*
       BYTE A0,N16
       BYTE E1,N16
       BYTE A1,N16
       BYTE REST,N8DOT
* Measure 7
       BYTE B0,N16
       BYTE E1,N16
       BYTE Gs1,N16
       BYTE REST,N8DOT
*
       BYTE A0,N16
       BYTE E1,N16
       BYTE A1,N16
       BYTE REST,N16
*
       DATA REPEAT,BEET3

       END
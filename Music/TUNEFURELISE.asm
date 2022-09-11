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
* 4/4
       BYTE C2,N4
       BYTE D2,N4
       BYTE E2,N4
       BYTE F2,N4
       BYTE G2,N4
       BYTE A2,N4
       BYTE B2,N4
*
       DATA REPEAT,BEET1

BEET2
* 4/4
       BYTE C3,N4
       BYTE D3,N4
       BYTE E3,N4
       BYTE F3,N4
       BYTE G3,N4
       BYTE A3,N4
       BYTE B3,N4
*
       DATA REPEAT,BEET2

BEET3
* 4/4
       BYTE C4,N4
       BYTE D4,N4
       BYTE E4,N4
       BYTE F4,N4
       BYTE G4,N4
       BYTE A4,N4
       BYTE B4,N4
*
       DATA REPEAT,BEET3

       END
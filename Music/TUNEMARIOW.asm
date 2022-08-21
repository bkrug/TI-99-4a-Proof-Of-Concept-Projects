       DEF  WINTR1,WINTR2,WINTR3

       COPY 'NOTEVAL.asm'
       COPY 'CONST.asm'


* https://musescore.com/thenewmaestro/scores/51866
* Super Mario World Overworld Theme
MWRLD1
WINTR1
* 4/4
       DATA D3,N4
       DATA Bb2,N8+N16
       DATA F2,N16
       DATA E2,N8
       DATA F2,N16
       DATA G2,N16+N4
*
MW1
       DATA A2,N8
       DATA A2,N8TRP
       DATA A2,N16TRP
       DATA A2,N8
       DATA A2,N8TRP
       DATA A2,N16TRP
       DATA Bb2,N8
       DATA Bb2,N8TRP
       DATA Bb2,N16TRP
       DATA Bb2,N8
       DATA Bb2,N8TRP
       DATA Bb2,N16TRP
*
       DATA A2,N8
       DATA A2,N8TRP
       DATA A2,N16TRP
       DATA A2,N8
       DATA A2,N8TRP
       DATA A2,N16TRP
       DATA Bb2,N8
       DATA Bb2,N4+N8
*
       DATA REPEAT,MW1

MWRLD2
WINTR2
* 4/4
       DATA REST,N1
*
MW2
       DATA F2,N8
       DATA F2,N8TRP
       DATA F2,N16TRP
       DATA F2,N8
       DATA F2,N8TRP
       DATA F2,N16TRP
       DATA G2,N8
       DATA G2,N8TRP
       DATA Gb2,N16TRP
       DATA Gb2,N8
       DATA Gb2,N8TRP
       DATA Gb2,N16TRP
*
       DATA F2,N8
       DATA F2,N8TRP
       DATA F2,N16TRP
       DATA F2,N8
       DATA F2,N8TRP
       DATA F2,N16TRP
       DATA G2,N8
       DATA Gb2,N4+N8
*
       DATA REPEAT,MW2

MWRLD3
WINTR3
* 4/4
       DATA REST,N1
*
MW3
       DATA F1,N4
       DATA D1,N4
       DATA G1,N4
       DATA C1,N4
*
       DATA F1,N4
       DATA D1,N4
       DATA G1,N8
       DATA C1,N4+N8
*
       DATA REPEAT,MW3

       END
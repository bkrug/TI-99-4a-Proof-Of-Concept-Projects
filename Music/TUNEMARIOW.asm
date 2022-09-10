       DEF  MWRLD

       COPY 'NOTEVAL.asm'
       COPY 'CONST.asm'

*
* Song Header
*
MWRLD  DATA MWRLD1,MWRLD2,MWRLD3
* Duration ratio in 60hz environment
       DATA 1,1
* Duration ratio in 50hz environment
       DATA 5,6

* https://musescore.com/thenewmaestro/scores/51866
* Super Mario World Overworld Theme
MWRLD1
* 4/4
       BYTE D3,N4
       BYTE Bb2,N8DOT
       BYTE F2,N16
       BYTE E2,N8
       BYTE F2,N16
       BYTE G2,N16+N4
*
MW1
       BYTE A2,N8
       BYTE A2,N8TRP
       BYTE A2,N16TRP
       BYTE A2,N8
       BYTE A2,N8TRP
       BYTE A2,N16TRP
       BYTE Bb2,N8
       BYTE Bb2,N8TRP
       BYTE Bb2,N16TRP
       BYTE Bb2,N8
       BYTE Bb2,N8TRP
       BYTE Bb2,N16TRP
*
       BYTE A2,N8
       BYTE A2,N8TRP
       BYTE A2,N16TRP
       BYTE A2,N8
       BYTE A2,N8TRP
       BYTE A2,N16TRP
       BYTE Bb2,N8
       BYTE Bb2,N4DOT
* Measure 4
       BYTE A2,N4
       BYTE F2,N8DOT
       BYTE C2,N16
       BYTE D2,N16
       BYTE F2,N8
       BYTE F2,N8DOT
       BYTE REST,N16
       BYTE D2,N16
*
       BYTE C2,N8
       BYTE F2,N8
       BYTE F2,N8
       BYTE C3,N8
       BYTE A2,N8DOT
       BYTE G2,N16
       BYTE G2,N4
*
       BYTE A2,N4
       BYTE F2,N8DOT
       BYTE C2,N16

       BYTE D2,N16
       BYTE F2,N8
       BYTE F2,N8DOT
       BYTE REST,N16
       BYTE D2,N16
*
       BYTE C2,N8
       BYTE F2,N8
       BYTE Bb2,N16
       BYTE A2,N16
       BYTE G2,N16
       BYTE F2,N16
       BYTE F2,N2
* Measure 8
       BYTE A2,N4
       BYTE F2,N8DOT
       BYTE C2,N16
       BYTE D2,N16
       BYTE F2,N8
       BYTE F2,N8DOT
       BYTE REST,N16
       BYTE D2,N16
*
       BYTE C2,N8
       BYTE F2,N8
       BYTE F2,N8
       BYTE C3,N8
       BYTE A2,N8DOT
       BYTE G2,N16
       BYTE G2,N4
*
       BYTE A2,N4
       BYTE F2,N8DOT
       BYTE C2,N16
       BYTE D2,N16
       BYTE F2,N8
       BYTE F2,N8DOT
       BYTE REST,N16
       BYTE D2,N16
*
       BYTE C2,N8
       BYTE F2,N8
       BYTE Bb2,N16
       BYTE A2,N16
       BYTE G2,N16
       BYTE F2,N16
       BYTE F2,N2
* Measure 12
       BYTE A2,N8DOT
       BYTE F2,N8DOT
       BYTE C2,N8
       BYTE A2,N8DOT
       BYTE F2,N16
       BYTE F2,N4
*
       BYTE Ab2,N16
       BYTE F2,N16
       BYTE C2,N8
       BYTE Ab2,N8DOT
       BYTE G2,N16
       BYTE G2,N2
*
       BYTE A2,N8DOT
       BYTE F2,N8DOT
       BYTE C2,N8
       BYTE A2,N8DOT
       BYTE F2,N16
       BYTE F2,N4
*
       BYTE Ab2,N16
       BYTE F2,N16
       BYTE C2,N8
       BYTE C3,N2DOT
* Measure 16
       BYTE A2,N4
       BYTE F2,N8DOT
       BYTE C2,N16
       BYTE D2,N16
       BYTE F2,N8
       BYTE F2,N8DOT
       BYTE REST,N16
       BYTE G2,N16
*
       BYTE A2,N16
       BYTE F2,N16
       BYTE C2,N8
       BYTE D2,N8DOT
       BYTE F2,N2
       BYTE D2,N16
*
       BYTE C3,N8
       BYTE D3,N8
       BYTE C3,N8
       BYTE D3,N8
       BYTE C3,N4
       BYTE Bb2,N16
       BYTE A2,N16
       BYTE G2,N8
*
       BYTE F2,N1
* Measure 20
       BYTE F2,N16
       BYTE D2,N8
       BYTE F2,N8DOT
       BYTE G2,N8
       BYTE A2,N16
       BYTE Gs2,N16
       BYTE G2,N16
       BYTE Fs2,N4
       BYTE REST,N16
*
       BYTE F2,N16
       BYTE D2,N8
       BYTE F2,N8DOT
       BYTE G2,N8
       BYTE A2,N2
*
       BYTE F2,N16
       BYTE D2,N8
       BYTE F2,N8DOT
       BYTE G2,N8
       BYTE A2,N16
       BYTE Bb2,N16
       BYTE C3,N16
       BYTE D3,N4
       BYTE REST,N16
*
       BYTE F2,N16
       BYTE D2,N8
       BYTE F2,N8DOT
       BYTE G2,N8
       BYTE F2,N2
*
       DATA REPEAT,MW1

MWRLD2
* 4/4
       BYTE REST,N1
*
MW2
       BYTE F2,N8
       BYTE F2,N8TRP
       BYTE F2,N16TRP
       BYTE F2,N8
       BYTE F2,N8TRP
       BYTE F2,N16TRP
       BYTE G2,N8
       BYTE G2,N8TRP
       BYTE Gb2,N16TRP
       BYTE Gb2,N8
       BYTE Gb2,N8TRP
       BYTE Gb2,N16TRP
*
       BYTE F2,N8
       BYTE F2,N8TRP
       BYTE F2,N16TRP
       BYTE F2,N8
       BYTE F2,N8TRP
       BYTE F2,N16TRP
       BYTE G2,N8
       BYTE Gb2,N4DOT
* Measure 4
       BYTE REST,NDBL
       BYTE REST,NDBL
* Measure 8
       BYTE REST,NDBL
       BYTE REST,NDBL
* Measure 12
       BYTE REST,NDBL
       BYTE REST,NDBL
* Measure 16
       BYTE REST,NDBL
       BYTE REST,NDBL
* Measure 20
       BYTE D2,N16
       BYTE Bb1,N8
       BYTE D2,N8DOT
       BYTE E2,N8
       BYTE F2,N16
       BYTE E2,N16
       BYTE E2,N16
       BYTE D2,N4
       BYTE REST,N16
*
       BYTE D2,N16
       BYTE Bb1,N8
       BYTE D2,N8DOT
       BYTE E2,N8
       BYTE F2,N2
*
       BYTE D2,N16
       BYTE Bb1,N8
       BYTE D2,N8DOT
       BYTE E2,N8
       BYTE F2,N16
       BYTE G2,N16
       BYTE A2,N16
       BYTE Bb2,N4
       BYTE REST,N16
*
       BYTE D2,N16
       BYTE Bb1,N8
       BYTE D2,N8DOT
       BYTE E2,N8
       BYTE C2,N2
*
       DATA REPEAT,MW2

MWRLD3
* 4/4
       BYTE REST,N1
*
MW3
       BYTE F1,N4
       BYTE D1,N4
       BYTE G1,N4
       BYTE C1,N4
*
       BYTE F1,N4
       BYTE D1,N4
       BYTE G1,N8
       BYTE C1,N4DOT
* Measure 4
       BYTE F1,N4
       BYTE A1,N4
       BYTE Bb1,N4
       BYTE B1,N4
*
       BYTE A1,N4
       BYTE Ab1,N4
       BYTE G1,N8
       BYTE D1,N8
       BYTE E1,N8
       BYTE F1,N8
*
       BYTE F1,N4
       BYTE A1,N4
       BYTE Bb1,N4
       BYTE B1,N4
*
       BYTE C2,N8
       BYTE D1,N8
       BYTE E1,N8
       BYTE G1,N8
       BYTE F1,N8
       BYTE D1,N8
       BYTE F1,N4
* Measure 8
       BYTE F1,N4
       BYTE A1,N4
       BYTE Bb1,N4
       BYTE B1,N4
*
       BYTE A1,N4
       BYTE Ab1,N4
       BYTE G1,N8
       BYTE D1,N8
       BYTE E1,N8
       BYTE F1,N8
*
       BYTE F1,N4
       BYTE A1,N4
       BYTE Bb1,N4
       BYTE B1,N4
*
       BYTE C2,N8
       BYTE D1,N8
       BYTE E1,N8
       BYTE G1,N8
       BYTE F1,N8
       BYTE D1,N8
       BYTE F1,N8
       BYTE C1,N8
* Measure 12
       BYTE Bb1,N8
       BYTE B1,N8
       BYTE C2,N8
       BYTE D2,N8
       BYTE C2,N8
       BYTE A1,N8
       BYTE F1,N8
       BYTE A1,N8
*
       BYTE Bb1,N8
       BYTE B1,N8
       BYTE C2,N8
       BYTE D2,N8
       BYTE F2,N8
       BYTE E2,N8
       BYTE C2,N8
       BYTE Bb1,N8
*
       BYTE Bb1,N8
       BYTE A1,N8
       BYTE Bb1,N8
       BYTE C2,N8
       BYTE D2,N8
       BYTE F2,N8
       BYTE D2,N8
       BYTE Bb1,N8
*
       BYTE C2,N8
       BYTE D2,N8
       BYTE F2,N8
       BYTE C2,N8
       BYTE Bb2,N8
       BYTE A2,N8
       BYTE Bb2,N8
       BYTE G2,N8
* Measure 16
       BYTE F1,N4
       BYTE F1,N4
       BYTE Eb1,N4
       BYTE Eb1,N4
*
       BYTE D1,N4
       BYTE D1,N4
       BYTE Cs1,N4
       BYTE Cs1,N4
*
       BYTE F1,N4
       BYTE REST,N2DOT
*
       BYTE F2,N4
       BYTE C2,N4
       BYTE F2,N4
       BYTE F2,N4
* Measure 20
       BYTE F1,N8
       BYTE D1,N8
       BYTE F1,N8
       BYTE A1,N8
       BYTE Bb1,N8
       BYTE C2,N8
       BYTE Bb1,N8
       BYTE F1,N8
*
       BYTE F1,N8
       BYTE D1,N8
       BYTE F1,N8
       BYTE A1,N8
       BYTE F2,N8
       BYTE D2,N8
       BYTE C2,N8
       BYTE A1,N8
*
       BYTE F1,N8
       BYTE D1,N8
       BYTE F1,N8
       BYTE A1,N8
       BYTE C2,N8
       BYTE Bb1,N8
       BYTE A1,N8
       BYTE G1,N8
*
       BYTE F1,N8
       BYTE D1,N8
       BYTE F1,N8
       BYTE G1,N8
       BYTE F1,N8
       BYTE D1,N8
       BYTE E1,N4
*
       DATA REPEAT,MW3

       END

* Linus and Lucy
* https://musescore.com/user/28953060/scores/5344826
* Jurrasic Park
* https://musescore.com/user/26033266/scores/5211161
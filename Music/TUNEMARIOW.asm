       DEF  MWRLD1,MWRLD2,MWRLD3

       COPY 'NOTEVAL.asm'
       COPY 'CONST.asm'


* https://musescore.com/thenewmaestro/scores/51866
* Super Mario World Overworld Theme
MWRLD1
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
* Measure 4
       DATA A2,N4
       DATA F2,N8+N16
       DATA C2,N16
       DATA D2,N16
       DATA F2,N8
       DATA F2,N8+N16
       DATA REST,N16
       DATA D2,N16
*
       DATA C2,N8
       DATA F2,N8
       DATA F2,N8
       DATA C3,N8
       DATA A2,N8+N16
       DATA G2,N16
       DATA G2,N4
*
       DATA A2,N4
       DATA F2,N8+N16
       DATA C2,N16

       DATA D2,N16
       DATA F2,N8
       DATA F2,N8+N16
       DATA REST,N16
       DATA D2,N16
*
       DATA C2,N8
       DATA F2,N8
       DATA Bb2,N16
       DATA A2,N16
       DATA G2,N16
       DATA F2,N16
       DATA F2,N2
* Measure 8
       DATA A2,N4
       DATA F2,N8+N16
       DATA C2,N16
       DATA D2,N16
       DATA F2,N8
       DATA F2,N8+N16
       DATA REST,N16
       DATA D2,N16
*
       DATA C2,N8
       DATA F2,N8
       DATA F2,N8
       DATA C3,N8
       DATA A2,N8+N16
       DATA G2,N16
       DATA G2,N4
*
       DATA A2,N4
       DATA F2,N8+N16
       DATA C2,N16
       DATA D2,N16
       DATA F2,N8
       DATA F2,N8+N16
       DATA REST,N16
       DATA D2,N16
*
       DATA C2,N8
       DATA F2,N8
       DATA Bb2,N16
       DATA A2,N16
       DATA G2,N16
       DATA F2,N16
       DATA F2,N2
* Measure 12
       DATA A2,N8+N16
       DATA F2,N8+N16
       DATA C2,N8
       DATA A2,N8+N16
       DATA F2,N16
       DATA F2,N4
*
       DATA Ab2,N16
       DATA F2,N16
       DATA C2,N8
       DATA Ab2,N8+N16
       DATA G2,N16
       DATA G2,N2
*
       DATA A2,N8+N16
       DATA F2,N8+N16
       DATA C2,N8
       DATA A2,N8+N16
       DATA F2,N16
       DATA F2,N4
*
       DATA Ab2,N16
       DATA F2,N16
       DATA C2,N8
       DATA C3,N2+N4
* Measure 16
       DATA A2,N4
       DATA F2,N8+N16
       DATA C2,N16
       DATA D2,N16
       DATA F2,N8
       DATA F2,N8+N16
       DATA REST,N16
       DATA G2,N16
*
       DATA A2,N16
       DATA F2,N16
       DATA C2,N8
       DATA D2,N8+N16
       DATA F2,N2
       DATA D2,N16
*
       DATA C3,N8
       DATA D3,N8
       DATA C3,N8
       DATA D3,N8
       DATA C3,N4
       DATA Bb2,N16
       DATA A2,N16
       DATA G2,N8
*
       DATA F2,N1
* Measure 20
       DATA F2,N16
       DATA D2,N8
       DATA F2,N8+N16
       DATA G2,N8
       DATA A2,N16
       DATA Gs2,N16
       DATA G2,N16
       DATA Fs2,N4
       DATA REST,N16
*
       DATA F2,N16
       DATA D2,N8
       DATA F2,N8+N16
       DATA G2,N8
       DATA A2,N2
*
       DATA F2,N16
       DATA D2,N8
       DATA F2,N8+N16
       DATA G2,N8
       DATA A2,N16
       DATA Bb2,N16
       DATA C3,N16
       DATA D3,N4
       DATA REST,N16
*
       DATA F2,N16
       DATA D2,N8
       DATA F2,N8+N16
       DATA G2,N8
       DATA F2,N2
*
       DATA REPEAT,MW1

MWRLD2
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
* Measure 4
       DATA REST,NDBL+NDBL
* Measure 8
       DATA REST,NDBL+NDBL
* Measure 12
       DATA REST,NDBL+NDBL
* Measure 16
       DATA REST,NDBL+NDBL
* Measure 20
       DATA D2,N16
       DATA Bb1,N8
       DATA D2,N8+N16
       DATA E2,N8
       DATA F2,N16
       DATA E2,N16
       DATA E2,N16
       DATA D2,N4
       DATA REST,N16
*
       DATA D2,N16
       DATA Bb1,N8
       DATA D2,N8+N16
       DATA E2,N8
       DATA F2,N2
*
       DATA D2,N16
       DATA Bb1,N8
       DATA D2,N8+N16
       DATA E2,N8
       DATA F2,N16
       DATA G2,N16
       DATA A2,N16
       DATA Bb2,N4
       DATA REST,N16
*
       DATA D2,N16
       DATA Bb1,N8
       DATA D2,N8+N16
       DATA E2,N8
       DATA C2,N2
*
       DATA REPEAT,MW2

MWRLD3
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
* Measure 4
       DATA F1,N4
       DATA A1,N4
       DATA Bb1,N4
       DATA B1,N4
*
       DATA A1,N4
       DATA Ab1,N4
       DATA G1,N8
       DATA D1,N8
       DATA E1,N8
       DATA F1,N8
*
       DATA F1,N4
       DATA A1,N4
       DATA Bb1,N4
       DATA B1,N4
*
       DATA C2,N8
       DATA D1,N8
       DATA E1,N8
       DATA G1,N8
       DATA F1,N8
       DATA D1,N8
       DATA F1,N4
* Measure 8
       DATA F1,N4
       DATA A1,N4
       DATA Bb1,N4
       DATA B1,N4
*
       DATA A1,N4
       DATA Ab1,N4
       DATA G1,N8
       DATA D1,N8
       DATA E1,N8
       DATA F1,N8
*
       DATA F1,N4
       DATA A1,N4
       DATA Bb1,N4
       DATA B1,N4
*
       DATA C2,N8
       DATA D1,N8
       DATA E1,N8
       DATA G1,N8
       DATA F1,N8
       DATA D1,N8
       DATA F1,N8
       DATA C1,N8
* Measure 12
       DATA Bb1,N8
       DATA B1,N8
       DATA C2,N8
       DATA D2,N8
       DATA C2,N8
       DATA A1,N8
       DATA F1,N8
       DATA A1,N8
*
       DATA Bb1,N8
       DATA B1,N8
       DATA C2,N8
       DATA D2,N8
       DATA F2,N8
       DATA E2,N8
       DATA C2,N8
       DATA Bb1,N8
*
       DATA Bb1,N8
       DATA A1,N8
       DATA Bb1,N8
       DATA C2,N8
       DATA D2,N8
       DATA F2,N8
       DATA D2,N8
       DATA Bb1,N8
*
       DATA C2,N8
       DATA D2,N8
       DATA F2,N8
       DATA C2,N8
       DATA Bb2,N8
       DATA A2,N8
       DATA Bb2,N8
       DATA G2,N8
* Measure 16
       DATA F1,N4
       DATA F1,N4
       DATA Eb1,N4
       DATA Eb1,N4
*
       DATA D1,N4
       DATA D1,N4
       DATA Cs1,N4
       DATA Cs1,N4
*
       DATA F1,N4
       DATA REST,N4+N2
*
       DATA F2,N4
       DATA C2,N4
       DATA F2,N4
       DATA F2,N4
* Measure 20
       DATA F1,N8
       DATA D1,N8
       DATA F1,N8
       DATA A1,N8
       DATA Bb1,N8
       DATA C2,N8
       DATA Bb1,N8
       DATA F1,N8
*
       DATA F1,N8
       DATA D1,N8
       DATA F1,N8
       DATA A1,N8
       DATA F2,N8
       DATA D2,N8
       DATA C2,N8
       DATA A1,N8
*
       DATA F1,N8
       DATA D1,N8
       DATA F1,N8
       DATA A1,N8
       DATA C2,N8
       DATA Bb1,N8
       DATA A1,N8
       DATA G1,N8
*
       DATA F1,N8
       DATA D1,N8
       DATA F1,N8
       DATA G1,N8
       DATA F1,N8
       DATA D1,N8
       DATA E1,N4
*
       DATA REPEAT,MW3

       END

* Linus and Lucy
* https://musescore.com/user/28953060/scores/5344826
* Jurrasic Park
* https://musescore.com/user/26033266/scores/5211161
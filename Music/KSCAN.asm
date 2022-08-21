       DEF  KSCAN
*
       REF  BUTTON
*       REF  VDPREG

*
* Constants
*
       COPY 'CONST.asm'
       COPY 'CPUADR.asm'
*
MSKJ1F EQU  >0001         Mask when Joystick fire detected by CRU
MSKJ1L EQU  >0002         Mask when Joystick left detected by CRU
MSKJ1R EQU  >0004         Mask when Joystick right detected by CRU
MSKJ1D EQU  >0008         Mask when Joystick down detected by CRU
MSKJ1U EQU  >0010         Mask when Joystick up detected by CRU
MSKFYR EQU  >0040         Mask when "Q" key detected by CRU
MSKRGT EQU  >0020         Mask when "D" key detected by CRU
MSKLFT EQU  >0020         Mask when "S" key detected by CRU
MSKUP  EQU  >0040         Mask when "U" key detected by CRU
MSKDWN EQU  >0080         Mask when "X" key detected by CRU

* Scan column, row mask, button flag
SCNDAT DATA >0900,MSKDWN,FLGDWN        Column 1
       DATA >0900,MSKLFT,FLGLFT
       DATA >0A00,MSKUP,FLGUP          Column 2
       DATA >0A00,MSKRGT,FLGRGT
       DATA >0D00,MSKFYR,FLGFYR        Column 5
       DATA >0E00,MSKJ1F,FLGFYR        Column 6 (joystick 1)
       DATA >0E00,MSKJ1L,FLGLFT
       DATA >0E00,MSKJ1R,FLGRGT
       DATA >0E00,MSKJ1U,FLGUP
       DATA >0E00,MSKJ1D,FLGDWN
       DATA >0F00,MSKJ1F,FLGFYR        Column 7 (joystick 2)
       DATA >0F00,MSKJ1L,FLGLFT
       DATA >0F00,MSKJ1R,FLGRGT
       DATA >0F00,MSKJ1U,FLGUP
       DATA >0F00,MSKJ1D,FLGDWN
SCNEND
* Length of a row of scan data in bytes
SCNL   EQU  6

*
* Public Method:
* Scan Keyboard and Joysticks
* Place reslts in BUTTON
*
KSCAN
       DECT R10
       MOV  R11,*R10
*
       CLR  @BUTTON
* Let R1 = position in SCNDAT
       LI   R1,SCNDAT
* Select column to scan
KSCAN1 MOV  *R1,R2
       LI   R12,>0024
       LDCR R2,4
* Put scaned keyboard rows in R3
       LI   R12,>0006
       CLR  R3
       STCR R3,8
       SWPB R3
* Test scan row
KSCAN2 CZC  @2(R1),R3
       JNE  KSCAN5
       MOV  @4(R1),R0
       SOC  R0,@BUTTON
* Next row of scan data
KSCAN5 AI   R1,6
       CI   R1,SCNEND
       JHE  KSCAN6
* If scanning another row in same column,
* then goto KSCAN2, else KSCAN1
       C    *R1,@-SCNL(R1)
       JEQ  KSCAN2
       JMP  KSCAN1
* If some button pressed, reset screen Saver
KSCAN6 MOV  @BUTTON,R0
       JEQ  KSCAN8
       LI   R1,-5*MINUTE
       MOV  R1,@VSAVER
* If screen currently off, redisplay it
*       LI   R0,VDP1DF
*       BL   @VDPREG
*
KSCAN8
       MOV  *R10+,R11
       RT
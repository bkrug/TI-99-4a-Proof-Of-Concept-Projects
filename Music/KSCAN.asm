       DEF  KSCAN
*
       REF  KEYTIM,CURKEY,PRVKEY
       REF  VDPREG

*
* Constants
*
       COPY 'CONST.asm'
       COPY 'CPUADR.asm'
*
COL0   EQU  >0800
COL1   EQU  >0900
COL2   EQU  >0A00
COL3   EQU  >0B00
COL4   EQU  >0C00
COL5   EQU  >0D00
COL6   EQU  >0E00
COL7   EQU  >0F00
FCTN   EQU  4
SHFT   EQU  5
CTRL   EQU  6

*
*  Column 0-5
*  Rows 0-7
*
*  *+    +++++
*  +=    .,MN/
*  +spc  LKJH;
*  +ent  OIUYP
*  +     98760
*  +fctn 23451
*  +shft SDFGA
*  +ctrl WERTQ
*  +     XCVBZ

ASCII
* Row 0 on left, Row 7 on right
* Column 0
       TEXT '='
       BYTE 32,13,0,FCTN,SHFT,CTRL,0
* Columns 1-5
       TEXT '.LO92SWX'
       TEXT ',KI83DEC'
       TEXT 'MJU74FRV'
       TEXT 'NHY65GTB'
       TEXT '/;P01AQZ'
* Amount of time to wait between key repeats
WAIT   DATA 30

*
* Public Method:
* Scan Keyboard and Joysticks
* Place reslts in BUTTON
*
KSCAN
       DECT R10
       MOV  R11,*R10
* Let R2 = current scan column
       LI   R2,COL0
* Select column to scan
KSCAN1 LI   R12,>0024
       LDCR R2,4
* Put scaned keyboard rows in R3 (high byte)
       LI   R12,>0006
       CLR  R3
       STCR R3,8
* Was any scan row in the column selected?
KSCAN2 CI   R3,>FF00
       JEQ  KSCAN7
* Yes, Let R4 = scanned row
       CLR  R4
       SRL  R3,8
KSCAN3 SRL  R3,1
       JNC  KEYDWN
       INC  R4
       JMP  KSCAN3
* No key pressed in this column
KSCAN7 AI   R2,>100
       CI   R2,COL5
       JLE  KSCAN1
* No Key pressed in any column
       JMP  KEYRT       

*
* Key is down
*
* R2 now has scan column
* R4 now has scan row
* Let R2 = column in lower byte * 8
KEYDWN AI   R2,-COL0
       SRL  R2,8-3
* Let R4 = address in ASCII
       A    R2,R4
       AI   R4,ASCII
* Is this the same as previous key?
       CB   *R4,@PRVKEY
       JNE  KD1
* Yes, has enough time passed?
       MOV  @KEYTIM,R0
       JEQ  KD1
* No, return to caller
       DEC  @KEYTIM
       JMP  KEYRT
* Save key
KD1    MOVB *R4,@CURKEY
       MOVB *R4,@PRVKEY
* Reset repeat timer and store previous key
       MOV  @WAIT,@KEYTIM
* Some button pressed, reset screen Saver
       LI   R1,-5*MINUTE
       MOV  R1,@VSAVER
* If screen currently off, redisplay it
       LI   R0,VDP1DF
       BL   @VDPREG

KEYRT
       MOV  *R10+,R11
       RT
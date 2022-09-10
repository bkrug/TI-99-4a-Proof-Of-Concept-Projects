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
ENTER  EQU  13

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
       TEXT '= '
       BYTE ENTER,0,FCTN,SHFT,CTRL,0
* Columns 1-5
       TEXT '.LO92SWX'
       TEXT ',KI83DEC'
       TEXT 'MJU74FRV'
       TEXT 'NHY65GTB'
       TEXT '/;P01AQZ'
* Value when no key has been pressed in a column
NOKEY  BYTE >FF
FCTNKY BYTE FCTN
ISFCTN BYTE FCTFLG
       EVEN
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
* Clear out previously scanned key
       SB   @CURKEY,@CURKEY
* Let R2 = current scan column
       LI   R2,COL0
* Select column to scan
KSCAN1 LI   R12,>0024
       LDCR R2,4
* Put scaned keyboard rows in R3 (high byte)
       LI   R12,>0006
       STCR R3,8
* Was any key in this column pressed?
KSCAN2 CB   R3,@NOKEY
       JNE  KSCAN3
* No, check next column
       AI   R2,>100
       CI   R2,COL5
       JLE  KSCAN1
* No key in any column was pressed
       JMP  KEYRT

*
* Some key in this column was pressed
*
KSCAN3
* Let R4 = scanned row
       CLR  R4
* Move scan results contents to lower byte
       SRL  R3,8
* Find first bit that contains 0 (pressed key).
KSCAN4 SRL  R3,1
       JNC  KEYDWN
       INC  R4
       JMP  KSCAN4      

*
* Key is down
*
* R2 now has scan column
* R4 now has scan row
*
* Let R2 = column in lower byte * 8
KEYDWN AI   R2,-COL0
       SRL  R2,8-3
* Let R4 = address in ASCII
       A    R2,R4
       AI   R4,ASCII
* Is this the FCTN key?
       CB   *R4,@FCTNKY
       JNE  KEYD0
* Yes, Set FCTN flag
* and continue scanning
       MOVB @ISFCTN,@CURKEY
       LI   R2,COL1
       JMP  KSCAN1
* No, record scanned key without disturbing FTCN flag
KEYD0  AB   *R4,@CURKEY       
* Is this the same as previous key?
       CB   @CURKEY,@PRVKEY
       JNE  KD1
* Yes, has enough time passed?
       MOV  @KEYTIM,R0
       JEQ  KD1
* No, clear scanned key and return to caller
       SB   @CURKEY,@CURKEY
       DEC  @KEYTIM
       JMP  KEYRT
* Retain CURKEY and mark that it is also the previous key
KD1    MOVB @CURKEY,@PRVKEY
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
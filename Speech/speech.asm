       REF  SPCHWT,SPCHRD,GPLWS,KSCAN
       DEF  START,DIRECT
PHROM  DATA 0
DATAAD DATA 0
SPDATA EQU  >8328
READIT EQU  >8330
RSA    DATA 0
SSA    DATA 0
H8000  DATA >8000
H4000  DATA >4000
HELLO  EQU  >351A
SPEECH DATA 118
       BYTE 166,209
       BYTE 198,37,104,82,151
       BYTE 206,91,138,224,232
       BYTE 116,186,18,85,130
       BYTE 204,247,169,124,180
       BYTE 116,239,185,183,184
       BYTE 197,45,20,32,131
       BYTE 7,7,90,29,179
       BYTE 6,90,206,91,77
       BYTE 136,166,108,126,167
       BYTE 181,81,155,177,233
       BYTE 230,0,4,170,236
       BYTE 1,11,0,170,100
       BYTE 53,247,66,175,185
       BYTE 104,185,26,150,25
       BYTE 208,101,228,106,86
       BYTE 121,192,234,147,57
       BYTE 95,83,228,141,111
       BYTE 118,139,83,151,106
       BYTE 102,156,181,251,216
       BYTE 167,58,135,185,84
       BYTE 49,209,106,4,0
       BYTE 6,200,54,194,0
       BYTE 59,176,192,3,0
       BYTE 0
STRING BYTE 5 
       TEXT 'HELLO' 
H50    BYTE >50 
H10    BYTE >10 
H60    BYTE >60 
HAA    BYTE >AA 
       EVEN 
CODE   MOV  @SPCHRD,@SPDATA 
       NOP 
       NOP 
       NOP 
       RT 
CLEN   EQU $-CODE 
DIRECT 
* Put read routine on 16-bit bus. 
       LI   R1,READIT 
       LI   R2,CODE 
       LI   R3,CLEN 
DR2    MOV  *R2+,*R1+ 
       DECT R3 
       JH   DR2 
       LI   R2,SPEECH 
       MOV  *R2+,R3 
       LI   R1,16 
       MOVB @H60,@SPCHWT 
       BL   @DLY12 
LOOPR 
       MOVB *R2+,@SPCHWT 
       DEC  R3 
       JEQ  OUT 
       DEC  R1
       JNE  LOOPR 
LOOPB 
       BL   @READIT 
       MOVB @SPDATA,R0
       COC  @H4000,R0
       JNE  LOOPB 
       LI   R1,8 
       JMP  LOOPR 
*
START 
* Put read routine on 16-bit bus. 
       LI   R1,READIT 
       LI   R2,CODE 
       LI   R3,CLEN 
ST2    MOV  *R2+,*R1+
       DECT R3 
       JH   ST2 
* Check for existence of Speech Synthesizer. 
       BL   @THERE 
       DATA OUT 
* Start looking after the validation byte. 
       INC  @PHROM 
SEARCH LI   R3,STRING 
       MOVB *R3+,R7            Length of target string. 
       SRL  R7,8 
       JEQ  OUT                 Null string. 
* 
       BL   @LOAD
       BL   @DLY42
       MOVB @H10,@SPCHWT
       BL   @DLY12
       BL   @READIT
       MOV  @SPDATA,R4
       SRL  R4,8
       INC  @PHROM
NEXT   
       BL   @LOAD
       BL   @DLY42
       MOVB @H10,@SPCHWT
       BL   @DLY12
       BL   @READIT
       CB   *R3+,@SPDATA
       JEQ  MATCH
       JH   HIGH
       JMP  LOW
MATCH
       INC  @PHROM
       DEC  R4
       JNE  STRN
       DEC  R7
       JEQ  SPEAK
HIGH
       LI   R8,2
       JMP  NXTPHR
STRN   DEC  R7
       JNE  NEXT
LOW
       CLR  R8
NXTPHR
       A    R4,@PHROM
       A    R8,@PHROM
       BL   @READ
       MOV  @DATAAD,R5
       JEQ  OUT
       MOV  R5,@PHROM
       JMP  SEARCH
*
SPEAK
       LI   R8,5
       A    R8,@PHROM
       BL   @READ
       BL   @DLY12
       MOV  @DATAAD,@PHROM
       BL   @LOAD
       BL   @DLY42
       MOVB @H50,@SPCHWT
       BL   @WAIT
       B    @START
WAIT
       MOV  R11,R10
       BL   @READIT
       MOV  @SPDATA,R0
       BLWP @KSCAN
       MOVB @>837C,R1
       JNE  OUT
       COC  @H8000,R0
       JEQ  WAIT
       B    *R10
OUT    LWPI GPLWS
       B    @>6A
* Read a word of data
* Address in PHROM, data returned in DATAAD
* Call with BL
READ   MOV  R11,@RSA
       BL   @LOAD
       BL   @DLY42
       MOVB @H10,@SPCHWT
       BL   @DLY12
       BL   @READIT
       MOVB @SPDATA,@DATAAD
       MOVB @H10,@SPCHWT
       BL   @DLY12
       BL   @READIT
       MOVB @SPDATA,@DATAAD+1
       MOV  @RSA,R11
       RT
* Check to see if the Speech Synthesizer is attached.
THERE  MOV  R11,@RSA
       CLR  @PHROM
       BL   @LOAD
       BL   @DLY42
       MOVB @H10,@SPCHWT
       BL   @DLY12
       BL   @READIT
       CB   @SPDATA,@HAA
       JEQ  RUN
* Not There
       MOV  @RSA,R11
       MOV  *R11,R11
       RT
* There
RUN    MOV  @RSA,R11
       INCT R11
       RT
* Load address.
* Called as BL   @LOAD with address in PHROM
* Uses R0, R1, and R2.
LOAD   MOV  @PHROM,R0
       LI   R2,4
LOADLP SRC  R0,4
       MOV  R0,R1
       SRC  R1,4
       ANDI R1,>0F00
       ORI  R1,>4000
       MOVB R1,@SPCHWT
       DEC  R2
       JNE  LOADLP
       LI   R1,>4000
       MOVB R1,@SPCHWT
       RT
DLY12  NOP
       NOP
       RT
DLY42  LI   R1,10
DLY42A DEC  R1
       JNE  DLY42A
       RT
       END
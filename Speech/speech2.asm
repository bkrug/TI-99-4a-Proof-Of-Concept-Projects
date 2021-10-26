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
SPEECH DATA 256
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >80
       BYTE >62
       BYTE >fa
       BYTE >4d
       BYTE >53
       BYTE >dd
       BYTE >26
       BYTE >8a
       BYTE >c9
       BYTE >77
       BYTE >6e
       BYTE >31
       BYTE >9b
       BYTE >28
       BYTE >a6
       BYTE >ed
       BYTE >a1
       BYTE >d8
       BYTE >15
       BYTE >22
       BYTE >5e
       BYTE >da
       BYTE >83
       BYTE >32
       BYTE >b3
       BYTE >89
       BYTE >2e
       BYTE >2f
       BYTE >1f
       BYTE >22
       BYTE >dc
       BYTE >11
       BYTE >aa
       BYTE >83
       BYTE >7d
       BYTE >08
       BYTE >8b
       BYTE >44
       BYTE >c8
       BYTE >83
       BYTE >ab
       BYTE >a9
       BYTE >d5
       BYTE >65
       BYTE >21
       BYTE >1f
       BYTE >7d
       BYTE >b6
       BYTE >65
       BYTE >53
       BYTE >88
       BYTE >42
       BYTE >fc
       BYTE >9c
       BYTE >d6
       BYTE >54
       BYTE >16
       BYTE >8a
       BYTE >49
       BYTE >5f
       BYTE >a8
       BYTE >50
       BYTE >49
       BYTE >80
       BYTE >62
       BYTE >70
       BYTE >d9
       BYTE >36
       BYTE >94
       BYTE >16
       BYTE >8a
       BYTE >cd
       BYTE >82
       BYTE >69
       BYTE >11
       BYTE >37
       BYTE >2c
       BYTE >09
       BYTE >0f
       BYTE >56
       BYTE >d1
       BYTE >12
       BYTE >b2
       BYTE >34
       BYTE >3c
       BYTE >5c
       BYTE >61
       BYTE >8d
       BYTE >c5
       BYTE >b2
       BYTE >f0
       BYTE >b0
       BYTE >4d
       BYTE >25
       BYTE >12
       BYTE >3b
       BYTE >dd
       BYTE >c5
       BYTE >50
       BYTE >b7
       BYTE >c8
       BYTE >24
       BYTE >13
       BYTE >8b
       BYTE >5d
       BYTE >dd
       BYTE >2b
       BYTE >93
       BYTE >9c
       BYTE >2d
       BYTE >0e
       BYTE >75
       BYTE >ab
       BYTE >45
       BYTE >72
       BYTE >bd
       BYTE >31
       BYTE >43
       BYTE >39
       BYTE >11
       BYTE >29
       BYTE >fc
       BYTE >81
       BYTE >71
       BYTE >e6
       BYTE >c4
       BYTE >28
       BYTE >0f
       BYTE >0f
       BYTE >d6
       BYTE >51
       BYTE >52
       BYTE >a3
       BYTE >3c
       BYTE >1c
       BYTE >d8
       BYTE >64
       BYTE >49
       BYTE >83
       BYTE >32
       BYTE >3d
       BYTE >a1
       BYTE >5b
       BYTE >34
       BYTE >09
       BYTE >ca
       BYTE >f0
       BYTE >c2
       BYTE >9c
       BYTE >30
       BYTE >c7
       BYTE >28
       BYTE >c7
       BYTE >13
       BYTE >7a
       BYTE >43
       BYTE >65
       BYTE >03
       BYTE >00
       BYTE >ca
       BYTE >dc
       BYTE >81
       BYTE >59
       BYTE >13
       BYTE >25
       BYTE >28
       BYTE >77
       BYTE >17
       BYTE >b6
       BYTE >59
       BYTE >54
       BYTE >a3
       BYTE >d2
       BYTE >3f
       BYTE >e8
       BYTE >51
       BYTE >56
       BYTE >82
       BYTE >aa
       BYTE >f0
       BYTE >60
       BYTE >9d
       BYTE >c4
       BYTE >33
       BYTE >aa
       BYTE >fd
       BYTE >85
       BYTE >09
       BYTE >52
       BYTE >87
       BYTE >a8
       BYTE >f1
       BYTE >07
       BYTE >db
       BYTE >cd
       BYTE >6c
       BYTE >a1
       BYTE >5a
       BYTE >6d
       BYTE >b2
       BYTE >94
       BYTE >b0
       BYTE >88
       BYTE >2a
       BYTE >39
       BYTE >c9
       BYTE >d2
       BYTE >54
       BYTE >16
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >00
       BYTE >1a
       BYTE >c2
       BYTE >7c
       BYTE >4e
       BYTE >55
       BYTE >5b
       BYTE >00
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
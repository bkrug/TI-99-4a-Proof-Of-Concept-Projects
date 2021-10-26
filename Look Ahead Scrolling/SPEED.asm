       DEF  START
*
* This program attempts to write as many bytes
* as possible to the VDP in 1/4 second.
* It starts copy from RAM address >0000 to
* VDP address >1000 and keeps going.
* It reports the number of bytes written
* at the end.
*
VDPWA  EQU  >8C02        VDP RAM write address
VDPRD  EQU  >8800        VDP RAM read data
VDPWD  EQU  >8C00        VDP RAM write data
VDPSTA EQU  >8802        VDP RAM status
REG1CP EQU  >83D4        Address holding a copy of VDP Register 1
* Address defining address of user-
* defined service routine
USRISR EQU  >83C4
TIMER  DATA 15
HEXTXT TEXT '    '
MSG    TEXT 'Starting'
       EVEN

*
       
START
* Initialize Program
       LI   R0,>3
       BL   @VDPADR       
       LI   R0,MSG
       LI   R1,8
       BL   @VDPWRT
* Define the interupt routine
       LI   R0,INTRPT
       MOV  R0,@USRISR
*
       LI   R0,>1000
       BL   @VDPADR
*
       LIMI 2
*
       CLR  R0
*
WRT    LIMI 0
       MOVB *R0+,@VDPWD
       NOP
       MOVB *R0+,@VDPWD
       NOP
       MOVB *R0+,@VDPWD
       NOP
       MOVB *R0+,@VDPWD
       NOP
       MOVB *R0+,@VDPWD
       NOP
       MOVB *R0+,@VDPWD
       NOP
       MOVB *R0+,@VDPWD
RPLFRM NOP
       MOVB *R0+,@VDPWD
       LIMI 2
RPLTO  JMP  WRT
* The contents of RPLTO will eventually be replaced by RPLFRM
* Done writing
DONE   LIMI 0
       LI   R1,HEXTXT
       BLWP @MAKETX
       LI   R0,>23
       BL   @VDPADR       
       LI   R0,HEXTXT
       LI   R1,4
       BL   @VDPWRT
       LIMI 2
JMP    JMP  JMP

INTRPT
* Decrease cursor time
       DEC   @TIMER
       JEQ   INTSTP
       RT
* Stop Writing
INTSTP MOV   @RPLFRM,@RPLTO
       RT

*
* Set VDP write address 
*
* Input:
* R0 - VDP address
* Output:
* R0 - bits 0 and 1 changed
VDPADR 
* Set most signfication two bits for 
* writing
       SZC  @BIT0,R0
       SOC  @BIT1,R0
* Write address to system
VDPAD1 SWPB R0
       MOVB R0,@VDPWA
       SWPB R0
       MOVB R0,@VDPWA
*
       RT
BIT0   DATA >8000
BIT1   DATA >4000

*
* Write multiple bytes to VDP
*
* Input:
* R0 - Address of text to copy
* R1 - Number of bytes
* Output:
* R0 - original value + R1's value
* R1 - 0
VDPWRT
* Don't write if R1 = 0
       MOV  R1,R1
       JEQ  VWRT2
* Write as many bytes as R1 specifies
VWRT1  MOVB *R0+,@VDPWD
       DEC  R1
       JNE  VWRT1
*
VWRT2  RT

* Make Hexadecimal Text
* ----------------------
* R0: Word to convert
* R1: Address of output text (4 bytes)
MAKETX DATA WORKSP,MAKEP
WORKSP BSS  >20
STACK  BSS  >100
MAKEP  LI   R12,STACK
       MOV  *R13,R0
       MOV  @2(R13),R1
       BL   @MAKEHX
       RTWP
MAKEHX MOV  R11,*R12+
       BL   @MAKEP1
       SWPB R0
       BL   @MAKEP1
       SWPB R0
* return
       DECT R12
       MOV  *R12,R11
       RT
 
MAKEP1 MOV  R11,*R12+
       MOV  R4,*R12+
* High Nibble
       MOVB R0,R4
       SRL  R4,4
       BL   @CONVB
       MOVB R4,*R1
       INC  R1
* Low Nibble
       MOVB R0,R4
       SLA  R4,4
       SRL  R4,4
       BL   @CONVB
       MOVB R4,*R1
       INC  R1
* Return
       DECT R12
       MOV  *R12,R4
       DECT R12
       MOV  *R12,R11
       RT
* Convert Byte to ASCII code
CONVB  CI   R4,>0A00
       JHE  CNVB2
       AI   R4,>3000
       RT
CNVB2  AI   R4,>3700
       RT

       END
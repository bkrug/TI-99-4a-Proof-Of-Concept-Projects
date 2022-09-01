       DEF  VDPREG,VDPUPD,VDPADR,VDPWRT
*
       REF  LBR0                               "

       COPY 'CPUADR.asm'
BIT0   DATA >8000
BIT1   DATA >4000

*
* Write to a VDP register
*
* Input:
* R0
* Output:
* R0
VDPREG
* VDP Reg 1, needs to be set to >F0
*       LI   R0,>01F0
* Specify that we are changing a register
       SOC  @BIT0,R0
       SZC  @BIT1,R0
* Write new value to copy byte
       SWPB R0
* TODO: Should we still copy Reg 1 to this address?
*       MOVB R0,@REG1CP
* Write new value to VDP register
       MOVB R0,@VDPWA
* Specify VDP register to change
       SWPB R0
       MOVB R0,@VDPWA
*
       RT

*
* Set VDP write address 
*
* Input:
* R0 - VDP address
* Output:
* R0 - bits 0 and 1 changed
VDPADR 
* Set most signficant two bits for writing
       SZC  @BIT0,R0
       SOC  @BIT1,R0
* Write address to system
VDPAD1 SWPB R0
       MOVB R0,@VDPWA
       SWPB R0
       MOVB R0,@VDPWA
*
       RT

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
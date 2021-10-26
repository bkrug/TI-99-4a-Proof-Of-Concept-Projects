********@*****@*********************@**************************
        AORG  >6000
*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
*GRMHDR  
       BYTE  >AA,1,1,0,0,0
       DATA  PROG
       BYTE  0,0,0,0,0,0,0,0
PROG   DATA  0
       DATA  START
*HW
       BYTE  TITLE1-TITLE
TITLE  TEXT  'SCROLL SAMPLE'
TITLE1
HWEND
       EVEN

*        DEF  START
*
*
VDPWA  EQU  >8C02        VDP RAM write address
VDPRD  EQU  >8800        VDP RAM read data
VDPWD  EQU  >8C00        VDP RAM write data
VDPSTA EQU  >8802        VDP RAM status
*
SCRNWD EQU  32
*
SCRN0  EQU  >400         VDP address of screen 0
SCRN1  EQU  >C00         VDP address of screen 1
SCRN2  EQU  >1400        VDP address of screen 2
CLR0   EQU  >1C00        VDP address of color 0
PAT0   EQU  >0           VDP address of pattern 0
PATLNG EQU  >800         length of each pattern table
*
TICKSP EQU  1            Number of ticks to wait between scrolls
ROWTCK EQU  4            Rows to write per tick
* Address defining address of user-
* defined service routine
USRISR EQU  >83C4

*
* Variables
*
WS     EQU  >A000
TIMER  EQU  WS+>20
*
SCRLFT EQU  TIMER+2
SCRMID EQU  SCRLFT+2
SCRRGT EQU  SCRMID+2
*
RMNROW EQU  SCRRGT+2      Remaining Rows to write on the new screen
CNTVDP EQU  RMNROW+2      VDP address to continue writing to new screen
CNTCPU EQU  CNTVDP+2      CPU address to continue reading screen from
*
DIR    EQU  CNTCPU+2      Scroll direction
LFTCOL EQU  DIR+2         Current column
LFTPIX EQU  LFTCOL+2      Pixel of current column
*
SND1TM EQU  LFTPIX+2      Remaining time for current note in sound generator 1
SND2TM EQU  SND1TM+2      Remaining time for current note in sound generator 2
SND1AD EQU  SND2TM+2      Address of next note for sound generator 1
SND2AD EQU  SND1AD+2      Address of next note for sound generator 2
*
STACK  EQU  SND2AD+>102
* Stack is 2 bytes shorter than what you see next to the plus sign

*
* Runable code
*
START
       LWPI WS
       LI   R12,STACK
* Initialize several variables
       LI   R0,TICKSP
       MOV  R0,@TIMER
*
       LI   R0,SCRN2
       MOV  R0,@SCRLFT
       LI   R0,SCRN0
       MOV  R0,@SCRMID
       LI   R0,SCRN1
       MOV  R0,@SCRRGT
*
       CLR  @RMNROW
       CLR  @CNTVDP
       CLR  @CNTCPU
*
       LI   R0,1
       MOV  R0,@DIR
*
       MOV  R0,@SND1TM
       MOV  R0,@SND2TM
       LI   R0,MUSIC1
       MOV  R0,@SND1AD
       LI   R0,MUSIC2
       MOV  R0,@SND2AD
* Define the interupt routine
       LI   R0,INTRPT
       MOV  R0,@USRISR
* Set Screen, Color, and Pattern locations
* through VDP registers
*
* Screen
       LI   R0,>0201
       BL   @VDPREG
* Color
       LI   R0,>0370
       BL   @VDPREG
* Pattern
       LI   R0,>0400
       BL   @VDPREG
*
* Write Screen Image
*
* Let R6 = Screens to write
* Let R7 = Current screen
       CLR  R6
       LI   R7,SCRN0
NXTSCN       
* Store Width in R2
* Store Remaining Height in R3
       MOV  @MS0,R2
       MOV  @MS0+1,R3
* Round up to nearest even
       INC  R2
       SRL  R2,1
       SLA  R2,1
* Set R4 to VDP address of row (skip three rows)
* Set R5 to CPU address of row
       MOV  R7,R4
       AI   R4,SCRNWD*3
       LI   R5,MD0
* Skip R6 columns
       A    R6,R5
* Clear top line
       MOV  R7,R0
       BL   @VDPADR
       LI   R1,SCRNWD*3
       SETO R0
CLRSCN MOVB R0,@VDPWD
       DEC  R1
       JNE  CLRSCN
* Write all screen Rows
WRTROW
       MOV  R4,R0
       BL   @VDPADR
       MOV  R5,R0
       LI   R1,SCRNWD
       BL   @VDPWRT
       AI   R4,SCRNWD
       A    R2,R5
       DEC  R3
       JNE  WRTROW
*
       AI   R7,PATLNG
       INC  R6
       CI   R6,3
       JL   NXTSCN
*
* Write colors
*
WRTCLR
       LI   R0,CLR0
       BL   @VDPADR
       LI   R0,CLRSET
       MOV  @CLRNUM,R1
       BL   @VDPWRT
*
* Write Patterns
*
WRTPTN
* Let R2 = pattern address in VDP
* Let R5 = number of pixels to shift
       LI   R2,PAT0
       CLR  R5
* Set VDP address of one pattern table
WRTP0
       MOV  R2,R0
       BL   @VDPADR
* Combine two unshifted bytes from transition characters
* Shift by amount in R5
       LI   R3,TCHARS
       MOV  @TCHNUM,R4
       SLA  R4,1
       A    R3,R4
* Let R6 = address of R1's lower byte
       LI   R6,WS+3
* Let R7 & R8 = address within two patterns       
WRTP1  MOVB *R3+,R7
       MOVB *R3+,R8
       SRL  R7,8
       SRL  R8,8
       S    @PATCOD,R7
       S    @PATCOD,R8
       SLA  R7,3
       SLA  R8,3
       AI   R7,PATTNS
       AI   R8,PATTNS
* Combine bytes at R7 & R8, shift, and write to VDP       
       LI   R9,8
WRTP2  MOVB *R7+,R1
       MOVB *R8+,*R6
       MOV  R5,R0
       JEQ  WRTP3
       SLA  R1,0
WRTP3  MOVB R1,@VDPWD
       DEC  R9
       JNE  WRTP2
* Continue to the end of the transition table
       C    R3,R4
       JL   WRTP1
       INC  R5
* Move to next one of 8 pattern tables
       AI   R2,PATLNG
       CI   R2,PATLNG*8
       JL   WRTP0
*
* Scroll a pixel at a time
*
* Let R2 = pixel scroll amount
* Let R3 = column scroll amount
       CLR  @LFTCOL
       CLR  @LFTPIX
* Turn on VDP interrupts
       LIMI 2
SCRLLP 
* Wait for VDP interupt
       MOV  @TIMER,@TIMER 
       JNE  SCRLLP
* Maybe change current note
       BL   @PLYMSC
* Write 1/6 of a screen if a request has been made
       BL   @WRTSCR
* Did we reach edge of screen?
       MOV  @LFTCOL,R2
       MOV  @LFTPIX,R3
       MOV  @DIR,@DIR
       JGT  SLP3
       A    R2,R3                * Moved left to where R2 + R3 = 0?
       JNE  SLP9
       JMP  SLP6
SLP3   CI   R2,7                 * Moving right
       JNE  SLP9
       MOV  @MS0,R4
       AI   R4,-SCRNWD
       C    R3,R4
       JNE  SLP9
* Yes, change direction       
SLP6   NEG  @DIR
* Change VDP registers and make request to draw new screen
SLP9   BL   @SCRPIX
*
       LIMI 2
* Repeat
       LI   R0,TICKSP
       MOV  R0,@TIMER
       JMP  SCRLLP

*
* scroll the screen 1-pixel left or right
* Look at DIR, LFTCOL, LFTPIX
*
SCRPIX
       DECT R12
       MOV  R11,*R12
       DECT R12
       MOV  R2,*R12
       DECT R12
       MOV  R3,*R12
*
       MOV  @LFTCOL,R2
       MOV  @LFTPIX,R3
* Change VDP Reg 4 to change pattern definitions
       LIMI 0
       A    @DIR,R2
       ANDI R2,7             Prevent R2 from going over 7
       MOV  R2,R0
       AI   R0,>400
       BL   @VDPREG
* Do we need to shift by a column now?
       MOV  @DIR,@DIR
       JLT  PIX10
       MOV  R2,R2
       JNE  PIXRT
       JEQ  PIX20
PIX10  CI   R2,7
       JNE  PIXRT
* Yes, Next column
PIX20  A    @DIR,R3
* Update left,right,center screens
       MOV  @DIR,@DIR
       JGT  PIX30
       MOV  @SCRRGT,R0
       MOV  @SCRMID,@SCRRGT
       MOV  @SCRLFT,@SCRMID
       MOV  R0,@SCRLFT
       JMP  PIX40
PIX30  MOV  @SCRLFT,R0
       MOV  @SCRMID,@SCRLFT
       MOV  @SCRRGT,@SCRMID
       MOV  R0,@SCRRGT
* Change VDP Reg 3 to change screen definition
PIX40  MOV  @SCRMID,R0
       SRL  R0,10
       AI   R0,>0200
       BL   @VDPREG
* Place request to write new right screen
       LI   R0,21
       MOV  R0,@RMNROW
*
       LI   R0,SCRMID
       A    @DIR,R0
       A    @DIR,R0
       MOV  *R0,R0
       AI   R0,SCRNWD*3
       MOV  R0,@CNTVDP
*
       MOV  R3,R0
       A    @DIR,R0
       AI   R0,MD0
       MOV  R0,@CNTCPU
* 
PIXRT
       MOV  R2,@LFTCOL
       MOV  R3,@LFTPIX
       MOV  *R12+,R3
       MOV  *R12+,R2
       MOV  *R12+,R11
       RT

*
* Write 1/6 of a screen if a write-request has been made
*
WRTSCR
       DECT R12
       MOV  R11,*R12
       DECT R12
       MOV  R2,*R12
*
       MOV  @RMNROW,@RMNROW
       JEQ  WRTRT
* Rows to write in this session
       LI   R2,ROWTCK       
* Write one row to VDP
WRTS0  MOV  @CNTVDP,R0
       BL   @VDPADR
       MOV  @CNTCPU,R0
       LI   R1,SCRNWD
       A    R1,@CNTVDP         *Update CNTVDP
       BL   @VDPWRT
* Update CNTCPU
       MOV  @MS0,R1
       INC  R1
       SRL  R1,1
       SLA  R1,1
       A    R1,@CNTCPU
* Update remaining row counts
       DEC  @RMNROW
       JEQ  WRTRT
       DEC  R2
       JNE  WRTS0
*
WRTRT
       MOV  *R12+,R2
       MOV  *R12+,R11
       RT

INTRPT DEC  @TIMER
       RT

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

PLYMSC DECT R12
       MOV  R11,*R12
* Store address of sound generator
       LI   R0,>8400
* Play from Tone Generator 1
       LI   R3,SND1AD
       LI   R4,SND1TM
       LI   R6,MUSIC1
       LI   R7,MEND1
       LI   R8,>9000
       BL   @PLYONE
* Play from Tone Generator 2
       LI   R3,SND2AD
       LI   R4,SND2TM
       LI   R6,MUSIC2
       LI   R7,MEND2
       LI   R8,>B000
       BL   @PLYONE
*
       MOV  *R12+,R11
       RT

NTPAUS DATA 2                       pause between notes (not same as a rest)
RESTVL DATA REST                    if this is in place of a tone, then do a rest
* R0 - address to send sound generator data to
* R3 - address of the next piece of data for sound generator
* R4 - address of the scheduled time to change generator tone
* R5 - address specifying if generator should now play silence
* R6 - address of beginning of sound generator data
* R7 - address of end of sound generator data
* R8 - used to change the generator's volume
PLYONE 
       DEC  *R4
       JEQ  NOTE
       C    *R4,@NTPAUS
       JH   PLYRT
* Turn off sound generator between notes
PAUS   AI   R8,>F00
       MOVB R8,*R0
       RT
* Play tone or rest?
NOTE   MOV  *R3,R1
       C    *R1,@RESTVL
       JNE  TONE
* Play rest. Turn off sound genrator
       AI   R8,>F00
       MOVB R8,*R0
       INCT R1
       JMP  TONE1
* Load tone and volume into sound address
TONE   MOVB *R1+,*R0
       NOP
       MOVB *R1+,*R0
       AI   R8,>800
       MOVB R8,*R0
* Set remaining time
TONE1  MOV  *R1+,*R4
* Restart music data if necessary
       C    R1,R7
       JNE  TONE2
       MOV  R6,R1
* Update position within music data
TONE2  MOV  R1,*R3
PLYRT  RT

****************************************
* Original Character Patterns           
****************************************
PATCOD DATA 96
PATTNS DATA >1818,>1818,>18FF,>7E3C    ; 
       DATA >0000,>0000,>0000,>0000    ; 
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0014,>1414,>1414,>1400    ; 
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >FEFE,>FFFF,>FFFF,>FFFF    ; unused
       DATA >0000,>111B,>9BBB,>FFFF    ; 
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >0000,>0000,>0000,>0000    ; unused
       DATA >FFFF,>FFEF,>FFFF,>FFFF    ; 
       DATA >FFFF,>FFFB,>FFBF,>FFFF    ; 
       DATA >FFEF,>C7EF,>FFFF,>FFFF    ; 
       DATA >FFFF,>FFFF,>EFC7,>EFFF    ; 
       DATA >FF81,>BDBD,>BDBD,>81FF    ; 
       DATA >FFFF,>FFFF,>FFFF,>FFFF    ; 
****************************************
* Colorset Definitions                  
****************************************
CLRNUM DATA 5                          ;
CLRSET BYTE >41,>B1,>E1,>E1            ;
       BYTE >E2                        ;
****************************************
* Transition Character Pairs (from, to) 
****************************************
TCHNUM DATA 35                         ;
TCHARS BYTE >61,>68                    ; #00 color 4/1
       BYTE >68,>61                    ; #01 color 4/1
       BYTE >FF,>FF                    ; #02 unused
       BYTE >FF,>FF                    ; #03 unused
       BYTE >FF,>FF                    ; #04 unused
       BYTE >FF,>FF                    ; #05 unused
       BYTE >FF,>FF                    ; #06 unused
       BYTE >FF,>FF                    ; #07 unused
       BYTE >61,>61                    ; #08 color B/1
       BYTE >61,>60                    ; #09 color B/1
       BYTE >60,>61                    ; #0A color B/1
       BYTE >FF,>FF                    ; #0B unused
       BYTE >FF,>FF                    ; #0C unused
       BYTE >FF,>FF                    ; #0D unused
       BYTE >FF,>FF                    ; #0E unused
       BYTE >FF,>FF                    ; #0F unused
       BYTE >7A,>78                    ; #10 color E/1
       BYTE >78,>79                    ; #11 color E/1
       BYTE >79,>78                    ; #12 color E/1
       BYTE >78,>7A                    ; #13 color E/1
       BYTE >61,>7D                    ; #14 color E/1
       BYTE >7D,>61                    ; #15 color E/1
       BYTE >61,>7C                    ; #16 color E/1
       BYTE >7C,>7C                    ; #17 color E/1
       BYTE >7C,>61                    ; #18 color E/1
       BYTE >7B,>79                    ; #19 color E/1
       BYTE >79,>7B                    ; #1A color E/1
       BYTE >FF,>FF                    ; #1B unused
       BYTE >FF,>FF                    ; #1C unused
       BYTE >FF,>FF                    ; #1D unused
       BYTE >FF,>FF                    ; #1E unused
       BYTE >FF,>FF                    ; #1F unused
       BYTE >7D,>71                    ; #20 color E/2
       BYTE >71,>71                    ; #21 color E/2
       BYTE >71,>7D                    ; #22 color E/2
****************************************
* Transition Map Data                   
****************************************
* == Map #0 ==                          
*MC0
       DATA 0                          ;
MS0    DATA >0033,>0015,>042F          ; Width, Height, Size
* -- Map Row 0 --                       
MD0    DATA >1011,>1213,>1011,>1213    ;
       DATA >1011,>1213,>1011,>1213    ;
       DATA >1011,>1213,>1011,>1213    ;
       DATA >1011,>1213,>1011,>1213    ;
       DATA >1011,>1213,>1011,>1213    ;
       DATA >1011,>1213,>1011,>1213    ;
       DATA >1011,>12FF                ;
* -- Map Row 1 --                       
       DATA >0808,>0808,>090A,>0808    ;
       DATA >0808,>0809,>0A08,>0808    ;
       DATA >0808,>090A,>0808,>0808    ;
       DATA >0809,>0A08,>0808,>0808    ;
       DATA >090A,>0808,>0808,>0809    ;
       DATA >0A08,>0808,>0808,>090A    ;
       DATA >0808,>08FF                ;
* -- Map Row 2 --                       
       DATA >0808,>0001,>0808,>0001    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0001,>0808,>0001,>0808    ;
       DATA >0808,>0808,>0808,>0001    ;
       DATA >0808,>0001,>0808,>0808    ;
       DATA >0808,>0808,>0001,>0808    ;
       DATA >0001,>08FF                ;
* -- Map Row 3 --                       
       DATA >0808,>0001,>0808,>0001    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0001,>0808,>0001,>0808    ;
       DATA >0808,>0808,>0808,>0001    ;
       DATA >0808,>0001,>0808,>0808    ;
       DATA >0808,>0808,>0001,>0808    ;
       DATA >0001,>08FF                ;
* -- Map Row 4 --                       
       DATA >0808,>0001,>0808,>0001    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0001,>0808,>0001,>0808    ;
       DATA >0808,>0808,>0808,>0001    ;
       DATA >0808,>0001,>0808,>0808    ;
       DATA >0808,>0808,>0001,>0808    ;
       DATA >0001,>08FF                ;
* -- Map Row 5 --                       
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>08FF                ;
* -- Map Row 6 --                       
       DATA >0814,>2021,>2121,>2122    ;
       DATA >1508,>0808,>0808,>0814    ;
       DATA >2021,>2121,>2122,>1508    ;
       DATA >0808,>0808,>0814,>2021    ;
       DATA >2121,>2122,>1508,>0808    ;
       DATA >0808,>0814,>2021,>2121    ;
       DATA >2122,>15FF                ;
* -- Map Row 7 --                       
       DATA >0816,>1717,>1717,>1717    ;
       DATA >1808,>0808,>0808,>0816    ;
       DATA >1717,>1717,>1717,>1808    ;
       DATA >0808,>0808,>0816,>1717    ;
       DATA >1717,>1717,>1718,>0808    ;
       DATA >0808,>0816,>1717,>1717    ;
       DATA >1717,>18FF                ;
* -- Map Row 8 --                       
       DATA >0808,>0808,>090A,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>090A,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >090A,>0808,>1617,>1808    ;
       DATA >0808,>0808,>0808,>090A    ;
       DATA >0808,>08FF                ;
* -- Map Row 9 --                       
       DATA >0808,>0001,>0808,>0001    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0001,>0808,>0001,>0808    ;
       DATA >0808,>0808,>0808,>0001    ;
       DATA >0808,>0001,>0816,>1718    ;
       DATA >0808,>0808,>0001,>0808    ;
       DATA >0001,>08FF                ;
* -- Map Row 10 --                      
       DATA >0808,>0001,>0808,>0001    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0001,>0808,>0001,>0808    ;
       DATA >0808,>0808,>0808,>0001    ;
       DATA >0808,>0001,>0808,>1617    ;
       DATA >1808,>0808,>0001,>0808    ;
       DATA >0001,>08FF                ;
* -- Map Row 11 --                      
       DATA >0808,>0001,>0808,>0001    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0001,>0808,>0001,>0808    ;
       DATA >0808,>0808,>0808,>0001    ;
       DATA >0808,>0001,>0808,>0816    ;
       DATA >1718,>0808,>0001,>0808    ;
       DATA >0001,>08FF                ;
* -- Map Row 12 --                      
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >1617,>1808,>0808,>0808    ;
       DATA >0808,>08FF                ;
* -- Map Row 13 --                      
       DATA >0814,>2021,>2121,>2122    ;
       DATA >1508,>0808,>0808,>0814    ;
       DATA >2021,>2121,>2122,>1508    ;
       DATA >0808,>0808,>0814,>2021    ;
       DATA >2121,>2122,>1508,>0808    ;
       DATA >0808,>0814,>2021,>2121    ;
       DATA >2122,>15FF                ;
* -- Map Row 14 --                      
       DATA >0816,>1717,>1717,>1717    ;
       DATA >1808,>0808,>0808,>0816    ;
       DATA >1717,>1717,>1717,>1808    ;
       DATA >0808,>0808,>1617,>1717    ;
       DATA >1717,>1717,>1808,>0808    ;
       DATA >0808,>0816,>1717,>1717    ;
       DATA >1717,>18FF                ;
* -- Map Row 15 --                      
       DATA >0808,>0808,>090A,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>090A,>0808,>0808    ;
       DATA >0808,>0816,>1718,>0808    ;
       DATA >090A,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>090A    ;
       DATA >0808,>08FF                ;
* -- Map Row 16 --                      
       DATA >0808,>0001,>0808,>0001    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0001,>0808,>0001,>0808    ;
       DATA >0808,>1617,>1808,>0001    ;
       DATA >0808,>0001,>0808,>0808    ;
       DATA >0808,>0808,>0001,>0808    ;
       DATA >0001,>08FF                ;
* -- Map Row 17 --                      
       DATA >0808,>0001,>0808,>0001    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0001,>0808,>0001,>0808    ;
       DATA >0816,>1718,>0808,>0001    ;
       DATA >0808,>0001,>0808,>0808    ;
       DATA >0808,>0808,>0001,>0808    ;
       DATA >0001,>08FF                ;
* -- Map Row 18 --                      
       DATA >0808,>0001,>0808,>0001    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0001,>0808,>0001,>0808    ;
       DATA >1617,>1808,>0808,>0001    ;
       DATA >0808,>0001,>0808,>0808    ;
       DATA >0808,>0808,>0001,>0808    ;
       DATA >0001,>08FF                ;
* -- Map Row 19 --                      
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0816    ;
       DATA >1718,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>0808,>0808,>0808    ;
       DATA >0808,>08FF                ;
* -- Map Row 20 --                      
       DATA >1912,>111A,>1912,>111A    ;
       DATA >1912,>111A,>1912,>111A    ;
       DATA >1912,>111A,>1912,>111A    ;
       DATA >1912,>111A,>1912,>111A    ;
       DATA >1912,>111A,>1912,>111A    ;
       DATA >1912,>111A,>1912,>111A    ;
       DATA >1912,>11FF                ;
       
       COPY   'TUNE.ASM'
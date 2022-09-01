       DEF  BEGIN
*
       REF  STACK,WS                        Ref from VAR
       REF  PRVTCK,NXTTCK                   "
       REF  PLYINT,PLYMSC                   Ref from DIRMUSIC
       REF  KSCAN                           Ref from KSCAN
       REF  PRCKEY                          Ref from SELECT

********@*****@*********************@**************************
*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
* Since this header is not absolutely positioned at >6000,
* it is important to include '-a ">6000"' in the xas99.py
* command when linking files into a cartridge.
       BYTE  >AA,1,1,0,0,0
       DATA  PROG
       BYTE  0,0,0,0,0,0,0,0      
*
PROG   DATA  0
       DATA  BEGIN
       BYTE  LVL3B-LVL3A
LVL3A  TEXT  'MUSIC TESTS'
LVL3B
       EVEN
       
*
* Addresses
*
       COPY 'CPUADR.asm'

*
* Runable code
*
BEGIN
       LWPI WS
       LI   R10,STACK
*
* Variable initialization routines
*
       BL   @PLYINT              Music variables
*
* Wait
*
* Let R0 = most recently read VDP time
WAIT   MOVB @VINTTM,R0
* Turn on VDP interrupts
       LIMI 2
* Wait for VDP interupt
WAITLP CB   @VINTTM,R0
       JEQ  WAITLP
* Turn off interrupts so we can write to VDP
       LIMI 0      
*
* Game Loop
*
GAMELP
* Scan keyboard
       BL   @KSCAN
* Process scanned key
       BL   @PRCKEY
* Maybe change current note
       BL   @PLYMSC
* Repeat
       JMP  WAIT
       DEF  BEGIN
*
       REF  STACK,WS                        Ref from VAR
       REF  PRVTCK,NXTTCK                   "
       REF  SONGHD,CURMNU,CURENV            "
       REF  PLYINT,PLYMSC                   Ref from DIRMUSIC
       REF  KSCAN                           Ref from KSCAN
       REF  PRCKEY                          Ref from SELECT
       REF  DSPINT,DSPENV                   Ref from DISPLAY
       REF  GROMCR                          Ref from GROM
       REF  MWRLD                           Ref from TUNEMARIOW

********@*****@*********************@**************************
*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
* Since this header is not absolutely positioned at >6000,
* it is important to include '-a ">6000"' in the xas99.py
* command when linking files into a cartridge.
       BYTE  >AA,1,1,0,0,0
       DATA  PROG1
       BYTE  0,0,0,0,0,0,0,0      
*
PROG1  DATA  0
       DATA  BEGIN
       BYTE  P1MSGE-P1MSG
P1MSG  TEXT  'ENVELOPE DEMO'
P1MSGE
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
       BL   @GROMCR              Copy pattern definitions from GROM to VRAM
*
       CLR  @CURENV              Set default envelope
       INC  @CURENV
       SB   @CURMNU,@CURMNU      Set current menu to "main"
       BL   @DSPINT              Write instructions to screen
*
       LI   R0,MWRLD
       MOV  R0,@SONGHD
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
* Display current envelope
       BL   @DSPENV
* Adjust tone and envelope
       BL   @PLYMSC
* Repeat
       JMP  WAIT
       DEF  BEGIN
*
       REF  STACK,WS                        Ref from VAR
       REF  PRVTCK,NXTTCK                   "
       REF  PLYINT,PLYMSC                   Ref from DIRMUSIC
       REF  KSCAN                           Ref from KSCAN

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
* Initialize timer
*
       BL   @BEGTIM
       BL   @GETTIM
       MOV  R2,@NXTTCK
*
* Wait
*
WAIT   MOV  @NXTTCK,@PRVTCK
       S    @TCKLN,@NXTTCK
       C    @NXTTCK,@PRVTCK
       JL   WAIT1
* Wait loop when NXTTCK is higher than PRVTCK
WAIT2  BL   @GETTIM
       C    R2,@NXTTCK
       JH   WAIT2
       C    R2,@PRVTCK
       JL   WAIT2
       JMP  GAMELP
* Wait loop when NXTTCK is lower than PRVTCK
WAIT1  BL   @GETTIM
       C    R2,@NXTTCK
       JL   GAMELP
       C    R2,@PRVTCK
       JLE  WAIT1       
*
* Game Loop
*
GAMELP
* Scan keyboard
       BL   @KSCAN
* Maybe change current note
       BL   @PLYMSC
* Repeat
       JMP  WAIT

*
* A CRU tick = 21.3 microseconds
* For this program a music tick is 1/3 as long as a 1/64th note.
* If one beat = 1/4 note,
* then at 132 PBM, a music tick = 9.4696969 milliseconds.
* Therefore, a music tick = 445 CRU ticks.
* Store this in the 14-leftmost bits
*
TCKLN  DATA 350*4

*
* Private Method:
* Initialize Timer
*
BEGTIM
       CLR  R12         CRU base of the TMS9901
       SBO  0           Enter timer mode
       LI   R1,>3FFF    Maximum value
       INCT R12         Address of bit 1
       LDCR R1,14       Load value
       DECT R12         There is a faster way (see http://www.nouspikel.com/ti99/titechpages.htm)
       SBZ  0           Exit clock mode, start decrementer
       RT

*
* Private Method:
* Get Time from CRU
* Output: R2 - leftmost 14 bits contains time
*
GETTIM CLR  R12
       SBO  0           Enter timer mode
       STCR R2,15       Read current value (plus mode bit)
       SBZ  0
       SRL  R2,1        Get rid of mode bit
       SLA  R2,2
       RT
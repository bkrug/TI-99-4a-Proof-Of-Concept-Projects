       DEF  STACK,WS
*
       DEF  SND1TM,SND2TM,SND3TM
       DEF  SND1AD,SND2AD,SND3AD
       DEF  SND1VL,SND2VL,SND3VL
*
       DEF  KEYTIM,CURKEY,PRVKEY
       DEF  CURENV,TONSEL
*
       DEF  PRVTCK,NXTTCK
*
       DEF  LBR0,LBR1,LBR2,LBR3,LBR4
       DEF  LBR5,LBR6,LBR7,LBR8,LBR9
       DEF  LBR13,LBR14,LBR15

*
* Constants
*
ENESZ  EQU  6             Number of bytes in an entry of ENERAM

*
* Variables
*
       AORG >8300
*
WS     BSS  >20
       BSS  >10
STACK
*
* MUSIC Variables
*
SND1AD BSS  2             Address of next note in sound generator 1
SND1TM BSS  2             Remaining time for current note
SND1VL BSS  2             Current Volume
SND2AD BSS  2             Address of next note in sound generator 2
SND2TM BSS  2             Remaining time for current note
SND2VL BSS  2             Current Volume
SND3AD BSS  2             Address of next note for sound generator 3
SND3TM BSS  2             Remaining time for current note
SND3VL BSS  2             Current Volume
*
* Timer variables
*
PRVTCK BSS  2
NXTTCK BSS  2
*
* KSCAN Variable
*
KEYTIM BSS  2             Time to wait before accepting repeated key
CURKEY BSS  1             Ascii for most recent key
PRVKEY BSS  1             Ascii for prev key
*
* selected envelope and tone generators
*
CURENV BSS  2
TONSEL BSS  2

*
* Skip 8 bytes at >8378, used for GPL status block
*
       AORG >8380
       RORG

*
* Scratch PAD usage outside programmer control.
* The below assumes that VDP Interrupts are enabled.
* From E/A manual page 404-406 and some independent research:
*
* >8370->837F GPL status block.
*             Seems like we can use the first 8 and last 4 bytes
*             but test carefully.
*       >8379       (byte) VDP interrupt timer. Incremented every 1/60th second.
*       >837A       (byte) number of sprites allowed in motion
*       >837B       (byte) VDP status byte
*
* >83C0->83DF Interpretter Workspace.
*             A routine at >0900 executes each VDP interrupt and uses this.
*       >83C4       (word) Address of user-defined interrupt
*       >83D6       (word) Screen time-out counter. Decrements every 1/60th second.
*       >83DA       (word) Player number used in some scan routine
*       >83DC       (word) undocumented. Switches between two values.
*       >83DE       (word) undocumented. Out of our control.
*
* >83E0->83FF GPL workspace registers.
*             It's a workspace. All of it is out of our control,
*             but writing to these addresses (words) in particular breaks our program.
*       >83E2
*       >83EA
*       >83F0
*       >83F6
*       >83F8
*       >83FC
*       >83FE

*
* Labels for lower bytes of registers
*
LBR0   EQU  WS+1
LBR1   EQU  WS+3
LBR2   EQU  WS+5
LBR3   EQU  WS+7
LBR4   EQU  WS+9
LBR5   EQU  WS+11
LBR6   EQU  WS+13
LBR7   EQU  WS+15
LBR8   EQU  WS+17
LBR9   EQU  WS+19

LBR13  EQU  WS+27
LBR14  EQU  WS+29
LBR15  EQU  WS+31
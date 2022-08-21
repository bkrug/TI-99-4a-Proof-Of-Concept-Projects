       DEF  STACK,WS,TIMER,VPAT,VSCRN
*
       DEF  DIR,WINDX
       DEF  SCRLFT,SCRMID,SCRRGT
       DEF  RMNROW,CNTVDP,SKPCOL
*
       DEF  HEROX,HEROY,HEROSP,HROYSP
       DEF  HROCLR
       DEF  GSTATS,REDPW,BLUPW,MAXPW
*
       DEF  REDGFT,BLUGFT
*
       DEF  SND1TM,SND2TM,SND3TM
       DEF  SND1AD,SND2AD,SND3AD
*
       DEF  CUTSCN,CUTSTT
*
       DEF  CURLVL
*
       DEF  BUTTON
*
       DEF  ENERAM,ENERE,ENESZ,ENESRC
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
* SCRNWRT Variables
*
DIR    BSS  2             Scroll direction
WINDX  BSS  2             The window's x position in pixels
*
SCRLFT BSS  2      
SCRMID BSS  2       
SCRRGT BSS  2       
*
RMNROW BSS  2             Remaining Rows to write on the new screen
CNTVDP BSS  2             VDP address to continue writing to new screen
SKPCOL BSS  2             CPU address to continue reading screen from
*
* HERO Variables
*
HEROX  BSS  2             The hero's x position in pixels * 32
HEROY  BSS  2             The hero's y position in pixels * 32
HEROSP BSS  2             The hero's horizontal speed in pixels per 60hz cycle / 32
HROYSP BSS  2             The hero's vertical speed
HROCLR BSS  1             Hero's color
MAXPW  BSS  1             Maximum power level for both shields
       EVEN               Place these at even address to clear them easily
REDPW  BSS  1             Remaining red power
BLUPW  BSS  1             Remaining blue power
*
* VDP variables
*
VPAT   BSS  1
VSCRN  BSS  1
*
* Shields on Gifts
*
       EVEN               Place these at even address to clear them easily
REDGFT BSS  1
BLUGFT BSS  1
*
* MUSIC Variables
*
SND1TM BSS  2             Remaining time for current note in sound generator 1
SND2TM BSS  2             Remaining time for current note in sound generator 2
SND3TM BSS  2             Remaining time for current note in sound generator 2
SND1AD BSS  2             Address of next note for sound generator 1
SND2AD BSS  2             Address of next note for sound generator 2
SND3AD BSS  2             Address of next note for sound generator 2
*
* Cut scene variables
*
CUTSCN BSS  2             Address of cut scene (0 implies no cut scene)
CUTSTT BSS  2             Number representing the cut scene status
*
* Graphics address variables
*
CURLVL BSS  2             Contains 0,2,4,6,8,... to represent levels 1,2,3,4,5...
*
* KSCAN Variable
*
*TODO: Consider changing this to a single byte
BUTTON BSS  2             Boolean flags for buttons
*
GSTATS BSS  1             Game status flags

*
* Skip 8 bytes at >8378, used for GPL status block
*
       AORG >8380
*
* ENEMY Variables
*
* Structure of element in ENERAM
*      BSS  1             Index of enemy in a ROM-array of enemy data.
*                         If this value contains >FF, then skip, it is empty.
*      BSS  1             Current Y position (use for sprite drawing and collision detection)
*      BSS  2             Current X position (")
*      BSS  2             Enemy state - a number used to calculate how far the enemy has moved.
*                         The enemy state could represent vertical movement for one enemy type,
*                         horizontal for another, or a point along a circle.
*
ENERAM BSS  11*ENESZ      Array of 6-byte long elements.
*                         Each element describes enemy position
ENERE
ENESRC BSS  2             ENEROM search position
*                         Each VDP interrupt, we pick one ENEROM element
*                         and check if we should add it to the ENERAM list
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
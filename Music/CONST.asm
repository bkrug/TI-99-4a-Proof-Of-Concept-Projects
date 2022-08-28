*
* Sound related
*
REST   EQU  >8FFF       Turn off sound generator for specified duration
STOP   EQU  >CFFF       Stop playing a signal/tune at end
REPEAT EQU  >CFFE       Play signal/tune as repeated loop
*
* Button flags
*
FLG0   EQU  >8000
FLG1   EQU  >4000
FLG2   EQU  >2000
FLG3   EQU  >1000
FLGA   EQU  >0800
FLGB   EQU  >0400
FLGC   EQU  >0200
FLGD   EQU  >0100
*
* Other
*
MINUTE EQU  3600          Length of minute in VDP Interrupts
VDP1DF EQU  >01E2         Default value for VDP Register 1
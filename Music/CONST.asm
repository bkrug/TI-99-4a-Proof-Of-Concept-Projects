*
* Sound related
*
REST   EQU  >7F         Turn off sound generator for specified duration
STOP   EQU  >CFFF       Stop playing a signal/tune at end
REPEAT EQU  >CFFE       Play signal/tune as repeated loop
*
* Other
*
MINUTE EQU  3600          Length of minute in VDP Interrupts
VDP1DF EQU  >01E2         Default value for VDP Register 1
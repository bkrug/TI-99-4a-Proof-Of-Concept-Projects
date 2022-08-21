*
* Sound related
*
REST   EQU  >8FFF       Turn off sound generator for specified duration
STOP   EQU  >CFFF       Stop playing a signal/tune at end
REPEAT EQU  >CFFE       Play signal/tune as repeated loop
*
* Button flags
*
FLGLFT EQU  >8000         Mask for left flag in button address
FLGRGT EQU  >4000         Mask for right flag in button address
FLGUP  EQU  >2000         Mask for up flag in button address
FLGDWN EQU  >1000         Mask for down flag in button address
FLGFYR EQU  >0800         Mask for fire flag in button address
*
* Other
*
MINUTE EQU  3600          Length of minute in VDP Interrupts
VDP1DF EQU  >01E2         Default value for VDP Register 1
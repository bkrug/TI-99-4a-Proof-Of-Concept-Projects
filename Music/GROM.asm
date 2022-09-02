       DEF  GROMCR
       REF  VDPADR

* Useful data is stored at these addresses:
* (Source: https://www.unige.ch/medecine/nouspikel/ti99/groms.htm)
*
* >0451 	Default values of the 8 VDP registers.
* >0459 	Content of the color table, for title screen.
* >04B4 	Characters 32 to 95 patterns, for title screen.
* >06B4 	Regular upper case character patterns.
* >0874 	Lower case character patterns.
* >16E0 	Joysticks codes returned by SCAN.
* >1700 	Key codes returned by SCAN.
* >1730 	Ditto with SHIFT.
* >1760 	Ditto with FCTN.
* >1790 	Ditto with CTRL.
* >17C0 	Key codes in keyboard modes 1 et 2 (half-keyboards).
* >2022 	Error messages (with Basic bias of >60, and lenght byte).
* >285C 	Reserved words in Basic, and corresponding tokens.

       COPY 'CPUADR.asm'

WRZERO DATA 7

*
* Get Char Patterns from GROM
*
* 7-bytes of each character's pattern definition
* is stored in GROM.
* The 8th byte is omitted and always equals 0.
*
* Most TI programs choose to leave the top row
* of each letter's char pattern blank.
* This code will shift the character up 1-pixel
* and leave the bottom row blank.
* This is in case I ever decide to redefine the
* lower-case chars and want letters like "y" and
* "g" to look okay.
*
GROMCR
       DECT R10
       MOV  R11,*R10
* Set GROM address
       LI   R3,>06B4
       MOVB R3,@GRMWA
       SWPB R3
       MOVB R3,@GRMWA
* Set VDP Write Address
       LI   R0,>0900
       BL   @VDPADR
* Let R0 = 0
* Let R1 = remaining bytes to write to VDP RAM
* Let R2 = source to read from
* Let R3 = destination to write to
       CLR  R0
       LI   R1,92*8-1
       LI   R2,GRMRD
       LI   R3,VDPWD
* Copy a byte from GROM to VDP RAM
GROM1  MOVB *R2,*R3
       DEC  R1
       JEQ  GROMRT
* Every 8th byte is excluded from the GROM
* Write 0 to the VDP RAM
       CZC  @WRZERO,R1
       JNE  GROM1
       MOVB R0,*R3
       DEC  R1
       JMP  GROM1
*
GROMRT MOV  *R10+,R11
       RT
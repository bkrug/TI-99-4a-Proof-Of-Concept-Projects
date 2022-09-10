       DEF  DSPINT,DSPENV
*
       REF  VDPADR,VDPWRT                   Ref from VDP
       REF  CURENV,HERTZ,CURMNU             Ref from VAR

HEADER TEXT '       ENVELOPE DEMO'
CURRNT TEXT '     Envelope _   _0 hz'
PRESS  TEXT 'Press:'
PRESS0

MAIN1  TEXT '1) Change Song'
MAIN2  TEXT '2) Change Envelope'
MAIN3  TEXT '3) Swap 60hz vs. 50hz'
MAIN0

SONG1  TEXT 'A) Mario World Overworld'
SONG2  TEXT 'B) Fu:r Elise'
SONG0

ENV1   TEXT 'A) Constant volume (no pause)'
ENV2   TEXT 'B) Constant volume'
ENV3   TEXT 'C) Sustain, release'
ENV4   TEXT 'D) Attack, release'
ENV5   TEXT 'E) Attack, sustain, release'
ENV6   TEXT 'F) Attack, decay, sustain,'
ENV6A  TEXT '   release'
ENV7   TEXT 'G) Repeated attacks'
ENV8   TEXT 'H) Repeated attacks and'
ENV8A  TEXT '   releases'
ENV9   TEXT 'I) Alternate between two'
ENV9A  TEXT '   volume levels'
ENV0
       EVEN

* Header above each menu
MHEAD  DATA HEADER,CURRNT,PRESS,PRESS
       DATA PRESS,PRESS
MHEAD0 DATA PRESS0

* Main menu
MMAIN  DATA MAIN1,MAIN2,MAIN3
MMAIN0 DATA MAIN0

* Sub menu for selecting song
MSONG  DATA SONG1,SONG2
MSONG0 DATA SONG0

* Sub menu for selecting envelope
MENV   DATA ENV1,ENV2,ENV3,ENV4
       DATA ENV5,ENV6,ENV6A,ENV7
       DATA ENV8,ENV8A,ENV9,ENV9A
MENV0  DATA ENV0

* Each menu indexed
MSTART DATA MMAIN,MSONG,MENV
* Each menu's end indexed
MEND   DATA MMAIN0,MSONG0,MENV0

       COPY 'CPUADR.asm'

*
* Public Method:
* Write key selections to screen
*
DSPINT
       DECT R10
       MOV  R11,*R10
* Let R2 = List of lines to display
* Let R3 = End of list of lines
* Let R4 = position of next line on screen
       LI   R2,MHEAD
       LI   R3,MHEAD0
       LI   R4,2
       BL   @DSPMNU
* Clear lower screen
       LI   R0,>C2
       BL   @VDPADR
       LI   R1,>300->C2
       LI   R2,>2000
DSP1   MOVB R2,@VDPWD
       DEC  R1
       JNE  DSP1
* Let R2 = address of current menu
* Let R3 = address of end of menu
       MOVB @CURMNU,R2
       SRL  R2,8-1
       MOV  R2,R3
       AI   R2,MSTART
       AI   R3,MEND
       MOV  *R2,R2
       MOV  *R3,R3
* Let R4 = position on screen
* Display it
       LI   R4,>C2
       BL   @DSPMNU
*
       MOV  *R10+,R11
       RT

*
* Private Method:
* Display a menu or menu header
*
DSPMNU DECT R10
       MOV  R11,*R10
*
       AI   R4,->20
* Set next position
MSGLP  AI   R4,>20
       MOV  R4,R0
       BL   @VDPADR
* Write next message
       MOV  *R2+,R0
       MOV  *R2,R1
       S    R0,R1
       BL   @VDPWRT
* Did we reach end of menu?
       C    R2,R3
       JL   MSGLP
* Yes, return
       MOV  *R10+,R11
       RT

*
* Public Method:
* Display current envelope
*
DSPENV
       DECT R10
       MOV  R11,*R10
* Display key that corresponds to current envelope
       LI   R0,>30
       BL   @VDPADR
*
       MOV  @CURENV,R1
       AI   R1,'A'
       SWPB R1
       MOVB R1,@VDPWD
* Display current electrical hertz
       LI   R0,>34
       BL   @VDPADR
*
       LI   R1,'6'*>100
       AB   @HERTZ,R1
       MOVB R1,@VDPWD
*
       MOV  *R10+,R11
       RT
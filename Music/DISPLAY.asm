       DEF  DSPINT,DSPENV
*
       REF  VDPADR,VDPWRT
       REF  CURENV

HEADER TEXT 'ENVELOPE DEMO'
HEAD0
CURRNT TEXT 'Current Envelope'
CURR0
MSG1   TEXT 'Press:'
MSG2   TEXT 'A) Constant volume (no pause)'
MSG3   TEXT 'B) Constant volume (pause'
MSG3A  TEXT '   between notes)'
MSG4   TEXT 'C) Sustain, release'
MSG5   TEXT 'D) Attack, release'
MSG6   TEXT 'E) Attack, sustain, release'
MSG7   TEXT 'F) Attack, decay, sustain,'
MSG7A  TEXT '   release'
MSG8   TEXT 'G) Repeated attacks'
MSG9   TEXT 'H) Repeated attacks and'
MSG9A  TEXT '   releases'
MSG10  TEXT 'I) Alternate between two'
MSG10A TEXT '   volume levels'
MSG11
       EVEN
MSGALL DATA MSG1,MSG2,MSG3,MSG3A,MSG4
       DATA MSG5,MSG6,MSG7,MSG7A,MSG8
       DATA MSG9,MSG9A,MSG10,MSG10A
MSGEND DATA MSG11

       COPY 'CPUADR.asm'

*
* Write key selections to screen
*
DSPINT
       DECT R10
       MOV  R11,*R10
*
       LI   R0,10
       BL   @VDPADR
       LI   R0,HEADER
       LI   R1,HEAD0-HEADER
       BL   @VDPWRT
*
       LI   R0,>47
       BL   @VDPADR
       LI   R0,CURRNT
       LI   R1,CURR0-CURRNT
       BL   @VDPWRT
* Let R2 = Position of next message
* Let R3 = position of next line on screen
       LI   R2,MSGALL
       LI   R3,>103->20
* Set next position
MSGLP  AI   R3,>20
       MOV  R3,R0
       BL   @VDPADR
* Write next message
       MOV  *R2+,R0
       MOV  *R2,R1
       S    R0,R1
       BL   @VDPWRT
*
       CI   R2,MSGEND
       JL   MSGLP
*
       MOV  *R10+,R11
       RT

*
* Display current envelope
*
DSPENV
       DECT R10
       MOV  R11,*R10
*
       LI   R0,>58
       BL   @VDPADR
*
       MOV  @CURENV,R1
       AI   R1,'A'
       SWPB R1
       MOVB R1,@VDPWD
*
       MOV  *R10+,R11
       RT
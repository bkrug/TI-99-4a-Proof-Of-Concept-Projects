       DEF  PRCKEY
*
       REF  CURKEY,PRVKEY               Ref from VAR
       REF  CURENV                      "
       REF  HERTZ,CURMNU                "
       REF  DSPINT                      Ref from DISPLAY
       REF  PLYINT                      Ref from MUSIC

* Range of keys to select a menu
LOWMNU BYTE '1'
HGHMNU BYTE '2'
CHGHTZ BYTE '3'
* Range of keys that can select an envelope
LOWENV BYTE 'A'
HGHENV BYTE 'I'
       EVEN

MNULST DATA MMAIN,MSONG,MENV

*
* Public Method: Process Keys
*
PRCKEY DECT R10
       MOV  R11,*R10
* What is the current menu?
       MOVB @CURMNU,R0
       SRL  R0,8-1
       AI   R0,MNULST
       MOV  *R0,R0
* Branch to it's routine       
       B    *R0

*
* Main menu
*
MMAIN
* Did the user decide to swap Hertz?
       CB   @CURKEY,@CHGHTZ
       JEQ  SWPHTZ
* No, did the user select a submenu?
       CB   @CURKEY,@LOWMNU
       JL   PRCRT
       CB   @CURKEY,@HGHMNU
       JH   PRCRT
* Yes, clear out key press
       MOVB @CURKEY,R0
       SB   R0,@CURKEY
* Record selection
       SB   @LOWMNU,R0
       SRL  R0,8
       INC  R0
       MOV  R0,@CURMNU
* Redisplay menu
       BL   @DSPINT
*
       JMP  PRCRT

*
* Song Sub-menu
*
MSONG

*
* Envelope Sub-menu
*
* Did the user select a new envelope?
MENV   CB   @CURKEY,@LOWENV
       JL   PRCRT
       CB   @CURKEY,@HGHENV
       JH   PRCRT
* Yes, clear out key press
       MOVB @CURKEY,R0
       SB   R0,@CURKEY
* Record selection
       SB   @LOWENV,R0
       SRL  R0,8
       MOV  R0,@CURENV
*
       JMP  PRCRT

*
* Switch between 60hz and 50hz
* Restart the song with new ratio
*
SWPHTZ
* clear key
       SB   @CURKEY,@CURKEY
* Is current mode 60hz?
       MOVB @HERTZ,R0
       JEQ  MK50HZ
* No, switch back to 60hz
       SB   @HERTZ,@HERTZ
       JMP  RESET
* Yes, switch to 50hz
MK50HZ SETO R0
       MOVB R0,@HERTZ
* Reset the song from the start
RESET  BL   @PLYINT
       JMP  PRCRT

*
* Return to caller
*
PRCRT  MOV  *R10+,R11
       RT
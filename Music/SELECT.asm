       DEF  PRCKEY
*
       REF  MWRLD,BEETHV                Ref from TUNEx
       REF  CURKEY,PRVKEY               Ref from VAR
       REF  CURENV                      "
       REF  SONGHD,HERTZ,CURMNU         "
       REF  DSPINT                      Ref from DISPLAY
       REF  PLYINT                      Ref from MUSIC

       COPY 'CONST.asm'

* Range of keys to select a sub menu
LOWMNU BYTE '1'
HGHMNU BYTE '2'
*
CHGHTZ BYTE '3'
ESCKEY BYTE FCTFLG+'9'
* Range of keys that can select a song
LOWSNG BYTE 'A'
HGHSNG BYTE 'B'
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
* Did user decide to return to main menu?
       CB   @CURKEY,@ESCKEY
       JEQ  BCKMNU 
* No, what is the current menu?
       MOVB @CURMNU,R0
       SRL  R0,8-1
       AI   R0,MNULST
       MOV  *R0,R0
* Branch to it's routine       
       B    *R0

*
* Return to main menu
*
BCKMNU
* Clear key selection
       SB   @CURKEY,@CURKEY
* Select main menu and redisplay
       SB   @CURMNU,@CURMNU
       JMP  MMAIN1

*
* Main menu
*
MMAIN
* Did the user decide to swap electrical system?
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
* If '1' pressed, set menu to >01, etc.
       SB   @LOWMNU,R0
       AI   R0,>100
       MOVB R0,@CURMNU
* Redisplay menu
MMAIN1 BL   @DSPINT
*
       JMP  PRCRT

*
* Song Sub-menu
*
MSONG
* Did the user select a submenu?
       CB   @CURKEY,@LOWSNG
       JL   PRCRT
       CB   @CURKEY,@HGHSNG
       JH   PRCRT
* Yes, clear out key press
       MOVB @CURKEY,R0
       SB   R0,@CURKEY
* Record selection
       SB   @LOWSNG,R0
       SRL  R0,8-1
       AI   R0,SNGLST
       MOV  *R0,@SONGHD
* Reset the song from the start
       BL   @PLYINT
*
       JMP  PRCRT

SNGLST DATA MWRLD,BEETHV

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
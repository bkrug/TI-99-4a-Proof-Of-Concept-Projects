       DEF  PRCKEY
       REF  CURKEY,PRVKEY
       REF  CURENV
       REF  HERTZ
       REF  PLYINT

* Range of keys that can select an envelope
LOWENV BYTE 'A'
HGHENV BYTE 'I'
CHERTZ BYTE 'Z'
       EVEN

*
* Public Method: Process Keys
*
PRCKEY DECT R10
       MOV  R11,*R10
* Did the user select a new envelope?
       CB   @CURKEY,@LOWENV
       JL   PRCRT
       CB   @CURKEY,@HGHENV
       JLE  SELENV
* No did the user select a different electrical system
       CB   @CURKEY,@CHERTZ
       JNE  PRCRT

* Yes, switch to other ratio
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

* Yes, clear out key press
SELENV MOVB @CURKEY,R0
       SB   R0,@CURKEY
* Record selection
       SB   @LOWENV,R0
       SRL  R0,8
       MOV  R0,@CURENV
*
PRCRT  MOV  *R10+,R11
       RT
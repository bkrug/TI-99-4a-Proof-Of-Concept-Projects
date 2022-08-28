       DEF  PRCKEY
       REF  CURKEY,PRVKEY
       REF  CURENV

* Range of keys that can select an envelope
LOWENV BYTE 'A'
HGHENV BYTE 'C'

*
* Public Method: Process Keys
*
PRCKEY
* Did the user select a new envelope?
       CB   @CURKEY,@LOWENV
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
PRCRT  RT
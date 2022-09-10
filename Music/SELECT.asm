       DEF  PRCKEY
       REF  CURKEY,PRVKEY
       REF  SONGHD,NOTERT,CURENV

* Address distance between 50hz and 60hz note-duration ratios
DURADR DATA 4
* Range of keys that can select an envelope
LOWENV BYTE 'A'
HGHENV BYTE 'I'
HERTZ  BYTE 'Z'
       EVEN

*
* Public Method: Process Keys
*
PRCKEY
* Did the user select a new envelope?
       CB   @CURKEY,@LOWENV
       JL   PRCRT
       CB   @CURKEY,@HGHENV
       JLE  SELENV
* No did the user select a different electrical system
       CB   @CURKEY,@HERTZ
       JNE  PRCRT

* Yes, switch to other ratio
* clear key
       SB   @CURKEY,@CURKEY
* Let R0 = address of 60hz ratio
       MOV  @SONGHD,R0
       AI   R0,6
* Is NOTERT pointing to the 60hz ratio?
       C    @NOTERT,R0
       JEQ  MK50HZ
* No, switch back to 60hz (4 bytes lower in memory)
       S    @DURADR,@NOTERT
       JMP  PRCRT
* Yes, switch to 50hz (4 bytes higher in memory)
MK50HZ
       A    @DURADR,@NOTERT
       JMP  PRCRT

* Yes, clear out key press
SELENV MOVB @CURKEY,R0
       SB   R0,@CURKEY
* Record selection
       SB   @LOWENV,R0
       SRL  R0,8
       MOV  R0,@CURENV
*
PRCRT  RT
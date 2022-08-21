       DEF  PLYINT,PLYMSC
*
       REF  SND1AD,SND2AD,SND3AD              Ref from VAR
       REF  SND1TM,SND2TM,SND3TM              "
       REF  CURLVL                            "
       REF  WINTR1,WINTR2,WINTR3              Ref from TUNEWINTER

*
* Constants
*
SGADR  EQU  >8400
       COPY 'CONST.asm'
       EVEN

*
* Initialize
*
PLYINT
* Start Music
       LI   R0,1
       MOV  R0,@SND1TM
       MOV  R0,@SND2TM
       MOV  R0,@SND3TM
       LI   R0,WINTR1
       MOV  R0,@SND1AD
       LI   R0,WINTR2
       MOV  R0,@SND2AD
       LI   R0,WINTR3
       MOV  R0,@SND3AD
*
       RT

*
* Executable
*
PLYMSC DECT R10
       MOV  R11,*R10
* Store address of sound generator
       LI   R0,SGADR
* Play from Tone Generator 1
       LI   R3,SND1AD
       LI   R4,SND1TM
       LI   R8,>9000
       LI   R9,>0800
       BL   @PLYONE
* Play from Tone Generator 2
       LI   R3,SND2AD
       LI   R4,SND2TM
       LI   R8,>B000
       LI   R9,>0800
       BL   @PLYONE
* Play from Tone Generator 3
       LI   R3,SND3AD
       LI   R4,SND3TM
       LI   R8,>D000
       LI   R9,>0800
       BL   @PLYONE
*
PLYMRT MOV  *R10+,R11
       RT

NTPAUS DATA 2                       pause between notes (not same as a rest)
RESTVL DATA REST                    if this is in place of a tone, then do a rest
STOPVL DATA STOP
REPTVL DATA REPEAT
*
* Stop non-repeating music
* Then turn-off sound generator
*
STOPMS CLR  *R3
       JMP  PAUS
*
* Loop to beginnign of tune, then run PLYONE routine like normal
*
* Increase *R4 from 0 to 1, so that note plays right away
* Put address of beginning of tune in *R3
REPTMS INC  *R4
       INCT R1
       MOV  *R1,*R3
*
* Check if a note has finished. If yes, then play a new one
*
* R0 - address to send sound generator data to
* R3 - address of address of the next piece of data for sound generator
* R4 - address of address of the scheduled time to change generator tone
* R8 - used to change the generator's volume
* R9 - desired volume
PLYONE 
* Let R1 = address of next note
       MOV  *R3,R1
* If R1 = 0, then skip
       JEQ  PAUS
* Play next note?
       DEC  *R4
       JEQ  NOTE
       C    *R4,@NTPAUS
       JH   PLYRT
* Turn off sound generator between notes
PAUS   AI   R8,>F00
       MOVB R8,*R0
       RT
NOTE
* Reached end of music loop?
NOTE1  C    *R1,@REPTVL
       JEQ  REPTMS
* No, reached end of non-repeating music?
       C    *R1,@STOPVL
       JEQ  STOPMS
* No, play tone or rest?
       C    *R1,@RESTVL
       JNE  TONE
* Play rest. Turn off sound genrator
       AI   R8,>F00
       MOVB R8,*R0
       INCT R1
       JMP  TONE1
* Play tone.
* Load tone into sound address. Have to select generator, too.
TONE   MOVB *R1+,R2
       AB   R8,R2
       AI   R2,->1000
       MOVB R2,*R0
       NOP
       MOVB *R1+,*R0
* Load Volume into sound address       
       AB   R9,R8
       MOVB R8,*R0
* Set remaining time
TONE1  MOV  *R1+,*R4
* Update position within music data
       MOV  R1,*R3
PLYRT  RT
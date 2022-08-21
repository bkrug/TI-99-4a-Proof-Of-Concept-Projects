       DEF  PLYINT,PLYMSC
*
       REF  SND1AD,SND2AD,SND3AD              Ref from VAR
       REF  SND1TM,SND2TM,SND3TM              "
       REF  SND1VL,SND2VL,SND3VL              "
       REF  WINTR1,WINTR2,WINTR3              Ref from TUNEWINTER

*
* Constants
*
SGADR  EQU  >8400
       COPY 'CONST.asm'
ONE    BYTE >01
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
       CLR  R0
       MOV  R0,@SND1VL
       MOV  R0,@SND2VL
       MOV  R0,@SND3VL
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
       LI   R5,SND1VL
       LI   R8,>9000
       BL   @PLYONE
* Play from Tone Generator 2
       LI   R3,SND2AD
       LI   R4,SND2TM
       LI   R5,SND2VL
       LI   R8,>B000
       BL   @PLYONE
* Play from Tone Generator 3
       LI   R3,SND3AD
       LI   R4,SND3TM
       LI   R5,SND3VL
       LI   R8,>D000
       BL   @PLYONE
*
PLYMRT MOV  *R10+,R11
       RT

NTPAUS DATA 2                       pause between notes (not same as a rest)
NTDIM  DATA >F+2                    point at which to reduce the volume
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
* R5 - address of current volume
* R8 - used to change the generator's volume
PLYONE 
* Let R1 = address of next note
       MOV  *R3,R1
* If R1 = 0, then skip
       JEQ  PAUS
* Play next note?
       DEC  *R4
       JEQ  NOTE
       C    *R4,@NTPAUS
       JLE  PAUS
       C    *R4,@NTDIM
       JLE  DIMVOL
       JMP  PLYRT
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
* Set volume to peek and load Volume into sound address
       CLR  *R5
       AB   *R5,R8
       MOVB R8,*R0
* Set remaining time
TONE1  MOV  *R1+,*R4
* Update position within music data
       MOV  R1,*R3
PLYRT  RT
*
* Reduce volume
*
DIMVOL AB   @ONE,*R5
       AB   *R5,R8
       MOVB R8,*R0
       RT
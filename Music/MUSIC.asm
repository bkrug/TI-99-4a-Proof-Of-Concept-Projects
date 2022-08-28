       DEF  PLYINT,PLYMSC
*
       REF  SND1AD,SND2AD,SND3AD              Ref from VAR
       REF  SND1TM,SND2TM,SND3TM              "
       REF  SND1VL,SND2VL,SND3VL              "
       REF  CURENV                            "
       REF  WINTR1,WINTR2,WINTR3              Ref from TUNEWINTER

*
* Constants
*
SGADR  EQU  >8400
       COPY 'CONST.asm'
SNDTIM EQU  2
SNDVOL EQU  4
ONE    BYTE >01
NOVOL  BYTE >0F
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
       AI   R0,-4
       MOV  R0,@SND1AD
       LI   R0,WINTR2
       AI   R0,-4
       MOV  R0,@SND2AD
       LI   R0,WINTR3
       AI   R0,-4
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
       LI   R8,>9000
       BL   @PLYONE
* Play from Tone Generator 2
       LI   R3,SND2AD
       LI   R8,>B000
       BL   @PLYONE
* Play from Tone Generator 3
       LI   R3,SND3AD
       LI   R8,>D000
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
REPTMS INC  @SNDTIM(R3)
       INCT R1
       MOV  *R1,*R3
       DECT *R3
       DECT *R3       
*
* Check if a note has finished. If yes, then play a new one
*
* R0 - address to send sound generator data to
* R3 - address of address of the next piece of data for sound generator
* R8 - used to change the generator's volume
PLYONE
       DECT R10
       MOV  R11,*R10
* Let R1 = address of current note
       MOV  *R3,R1
* If R1 = 0, then skip
       JEQ  PAUS
* Look at next data?
       DEC  @SNDTIM(R3)
       JNE  ENVELP
* Yes
       AI   R1,4
* Reached end of music loop?
       C    *R1,@REPTVL
       JEQ  REPTMS
* No, reached end of non-repeating music?
       C    *R1,@STOPVL
       JEQ  STOPMS
*
* Play tone.
*
* Load tone into sound address. Have to select generator, too.
TONE   MOVB *R1,R2
       AB   R8,R2
       AI   R2,->1000
       MOVB R2,*R0
       NOP
       MOVB @1(R1),*R0
* Set remaining time
       MOV  @2(R1),@SNDTIM(R3)
* Update position within music data
       MOV  R1,*R3
*
* Select Envelope
*
ENVELP 
* Let R4 = SNDVOL(R3)
       MOV  R3,R4
       AI   R4,SNDVOL
* Let R5 = address of current envelope
       MOV  @CURENV,R5
       SLA  R5,1
       AI   R5,ENVLST
       MOV  *R5,R5
* Call envelope to set the cur volume in *R4
       BL   *R5
* Set new volume
       AB   *R4,R8
       MOVB R8,*R0
*
       MOV  *R10+,R11
       RT

*
* Paus routine
*
PAUS   AI   R8,>F00
       MOVB R8,*R0
       RT

ENVLST DATA ENV0,ENV1,ENV2

*
* Envelope 0
* Flat max volume. No paus between notes.
*
ENV0
* Is this a rest?
       C    *R1,@RESTVL
       JNE  ENV0A
* Yes, turn off sound
       MOVB @NOVOL,*R4
       RT
* No, turn volume to top
ENV0A  SB   *R4,*R4
       RT

*
* Envelope 1
* Flat max volume with short paus between notes
*
ENV1
* Is this a rest?
       C    *R1,@RESTVL
       JEQ  ENV1A
* No, are we at end of note
       C    @SNDTIM(R3),@NTPAUS
       JH   ENV1B
* Yes, turn off sound
ENV1A  MOVB @NOVOL,*R4
       RT
* No, turn volume to top
ENV1B  SB   *R4,*R4
       RT

*
* Envelope 2
* Start at max volume, decrease during late cyles
*
NTDIM  DATA 16                      point at which to reduce the volume
ENV2
* Is this the begining of a note?
       C    @SNDTIM(R3),@2(R1)
       JNE  ENV2A
* Yes, is it a rest?
       C    *R1,@RESTVL
       JEQ  ENV2Y
* No, set volume to peek
       SB   *R4,*R4
       RT
* Are we at end of note?
ENV2A  C    @SNDTIM(R3),@NTPAUS
       JH   ENV2B
* Yes, turn off sound
ENV2Y  MOVB @NOVOL,*R4
       RT
* No, are we at point to dim volume?
ENV2B  C    @SNDTIM(R3),@NTDIM
       JHE  ENV2C
* Yes, decrease volume
       AB   @ONE,*R4
* Set the volume
ENV2C  RT

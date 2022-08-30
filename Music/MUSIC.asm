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
       DECT R10
       MOV  R11,*R10
* Start Music
       LI   R3,WINTR1
       MOV  R3,@SND1AD
       LI   R3,SND1AD
       LI   R8,>9000       
       BL   @STRTPL
*
       LI   R3,WINTR2
       MOV  R3,@SND2AD
       LI   R3,SND2AD
       LI   R8,>B000     
       BL   @STRTPL
*
       LI   R3,WINTR3
       MOV  R3,@SND3AD
       LI   R3,SND3AD
       LI   R8,>D000      
       BL   @STRTPL
* Select default envelope
       CLR  @CURENV
       INC  @CURENV
*
       MOV  *R10+,R11
       RT

*
* Executable
*
PLYMSC DECT R10
       MOV  R11,*R10
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
* Initialize stream of music for one tone generator
*
* R3 - address of address of the next piece of data for sound generator
* R8 - used to change the generator's volume
STRTPL
       DECT R10
       MOV  R11,*R10
* Let R1 = address of current note
       MOV  *R3,R1
*
       JMP  PLY1
*
* Loop to beginnign of tune for one tone generator
*
* R3 - address of address of the next piece of data for sound generator
* R8 - used to change the generator's volume
REPTMS MOV  @2(R1),*R3
       MOV  *R3,R1
       JMP  PLY1
*
* Check if a note has finished. If yes, then play a new one
*
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
PLY1   C    *R1,@REPTVL
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
       MOVB R2,@SGADR
       NOP
       MOVB @1(R1),@SGADR
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
       MOVB R8,@SGADR
*
       MOV  *R10+,R11
       RT

*
* Paus routine
*
PAUS   AI   R8,>F00
       MOVB R8,@SGADR
       RT

ENVLST DATA ENV0,ENV1,ENV2,ENV3,ENV6

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
* Sustain, Release
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

*
* Envelope 3
* Attack, Release
*
ENV3
* Is this a rest?
       C    *R1,@RESTVL
       JNE  ENV3M
* Yes, turn off volume
       MOVB @NOVOL,*R4
       RT
* Is this the begining of a note?
ENV3M  C    @SNDTIM(R3),@2(R1)
       JNE  ENV3B
* Yes, set volume to either off or half the max time
       MOV  @SNDTIM(R3),R5
       SRL  R5,1
       CI   R5,>F
       JLE  ENV3A
       LI   R5,>F
ENV3A  SLA  R5,8
       MOVB R5,*R4
       RT
* No, Let R6 = time to begin release
ENV3B  MOV  @2(R1),R6
       SRL  R6,1
       CI   R6,>10
       JL   ENV3C
       MOV  @2(R1),R6
       AI   R6,->10
* Are we in attack mode?
ENV3C  C    @SNDTIM(R3),R6
       JLE  ENV3D
* Yes, increase volume
       SB   @ONE,*R4
       RT
* No, is volume already off?
ENV3D  CB   *R4,@NOVOL
       JEQ  ENV3RT
* No, release
       AB   @ONE,*R4
*
ENV3RT RT

*
* Envelope 6
* Changing volume
*
ENV6
* Is this a rest?
       C    *R1,@RESTVL
       JEQ  ENV6A
* No, are we at end of note
       C    @SNDTIM(R3),@NTPAUS
       JH   ENV6B
* Yes, turn off sound
ENV6A  MOVB @NOVOL,*R4
       RT
* No, set volume acording to remaining time
ENV6B  MOV  @SNDTIM(R3),R5
       ANDI R5,7
       SLA  R5,8
       MOVB R5,*R4
       RT
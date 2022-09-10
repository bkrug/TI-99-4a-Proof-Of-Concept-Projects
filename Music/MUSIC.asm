       DEF  PLYINT,PLYMSC
*
       REF  SND1AD,SND2AD,SND3AD              Ref from VAR
       REF  CURENV,LBR5                       "
       REF  MWRLD                             Ref from TUNEWINTER
       REF  TTBL                              Ref from TONETABLE

*
* Constants
*
       COPY 'NOTEVAL.asm'
       COPY 'CPUADR.asm'
* Offsets within sound structure
SNDELP  EQU  2
SNDTIM  EQU  4
SNDVOL  EQU  6
SNDMOD  EQU  7
* Current ADSR Modes
MDATCK  EQU  0
MDDECY  EQU  1
MDSSTN  EQU  2
MDRELS  EQU  3
* Codes for different tone generators
TGN1    EQU  >8000
TGN2    EQU  >A000
TGN3    EQU  >C000
*
NOVOL  BYTE >0F
SETVOL BYTE >10
ONE    BYTE >01
       EVEN

*
* Initialize
*
PLYINT
       DECT R10
       MOV  R11,*R10
* Select default envelope
       CLR  @CURENV
       INC  @CURENV
* Start Music
       LI   R2,MWRLD
*
       LI   R0,TGN1
       MOV  *R2+,R1
       BL   @STRTPL
*
       LI   R0,TGN2
       MOV  *R2+,R1
       BL   @STRTPL
*
       LI   R0,TGN3
       MOV  *R2+,R1
       BL   @STRTPL
*
       MOV  *R10+,R11
       RT

*
* Executable
*
PLYMSC DECT R10
       MOV  R11,*R10
* Play from Tone Generator 1
       LI   R0,TGN1
       LI   R1,SND1AD
       BL   @PLYONE
* Play from Tone Generator 2
       LI   R0,TGN2
       LI   R1,SND2AD
       BL   @PLYONE
* Play from Tone Generator 3
       LI   R0,TGN3
       LI   R1,SND3AD
       BL   @PLYONE
*
PLYMRT MOV  *R10+,R11
       RT

NTPAUS DATA 2                       pause between notes (not same as a rest)
STOPVL DATA STOP
REPTVL DATA REPEAT
RESTVL BYTE REST                    if this is in place of a tone, then do a rest
       EVEN

*
* Initialize stream of music for one tone generator
*
* R0 - specifies the sound generator
* R1 - address of music for 1 sound generator
STRTPL
       DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R2,*R10
* Let R5 = address of Sound structure for current sound generator
       MOV  R0,R5
       AI   R5,-TGN1
       SRL  R5,12
       AI   R5,SNDSTR
       MOV  *R5,R5
* Move specified music to sound structure
       MOV  R1,*R5
* Let R1 = Addres of sound structure
* Let R2 = address of current note
       MOV  R5,R1
       MOV  *R5,R2
*
       JMP  PLY1

SNDSTR DATA SND1AD,SND2AD,SND3AD

*
* Check if a note has finished. If yes, then play a new one
*
* R0 - specifies the sound generator
* R1 - address of address of the next piece of data for sound generator
PLYONE
       DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R2,*R10
* Let R2 = address of current note
       MOV  *R1,R2
* If R2 = 0, then skip
       JEQ  STOPMS
* Look at next note?
       INC  @SNDELP(R1)
       DEC  @SNDTIM(R1)
       JNE  ENVELP
* Yes
       INCT R2
* Reached end of music loop?
PLY1   C    *R2,@REPTVL
       JEQ  REPTMS
* No, reached end of non-repeating music?
       C    *R2,@STOPVL
       JEQ  STOPMS
*
* Play tone.
*
* Look up tone-code based on note-code
       MOVB *R2,R5
       SRL  R5,8
       SLA  R5,1
       AI   R5,TTBL
* Load tone into sound address. Have to select generator, too.
       MOV  *R5,R8
       A    R0,R8
       MOVB R8,@SGADR
       SWPB R8
       MOVB R8,@SGADR
* Set elapsed time
       CLR  @SNDELP(R1)
* Set remaining time
       MOVB @1(R2),R8
       SRL  R8,8
       MOV  R8,@SNDTIM(R1)
* Update position within music data
       MOV  R2,*R1
*
* Select Envelope
*
ENVELP 
* Let R3 = SNDTIM(R1)
* Let R4 = SNDVOL(R1)
       MOV  R1,R3
       AI   R3,SNDTIM
       MOV  R1,R4
       AI   R4,SNDVOL
* Let R5 = address of current envelope
       MOV  @CURENV,R5
       SLA  R5,1
       AI   R5,ENVLST
       MOV  *R5,R5
* Call envelope to set the cur volume in *R4
       BL   *R5
* Set new volume
       AB   @SETVOL,R0
       AB   *R4,R0
       MOVB R0,@SGADR
*
PLY1RT MOV  *R10+,R2
       MOV  *R10+,R11
       RT

*
* Stop non-repeating music
* Then turn-off sound generator
*
STOPMS CLR  *R1
       AI   R0,>1F00
       MOVB R0,@SGADR
*
       JMP  PLY1RT

*
* Loop to beginnign of tune for one tone generator
*
REPTMS MOV  @2(R2),*R1
       MOV  *R1,R2
       JMP  PLY1

ENVLST DATA ENV0,ENV1,ENV2,ENV3
       DATA ENV4,ENV5,ENV6,ENV7
       DATA ENV8

*
* For each envelope routine the following parameters are already set
*
* R0 = value indicating current sound generator
* R1 = address of sound structure
* R2 = address of current note
* R3 = address of remaining time
* R4 = address of current volume
*

*
* Envelope 0
* Flat max volume. No paus between notes.
*
ENV0
* Is this a rest?
       CB   *R2,@RESTVL
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
       CB   *R2,@RESTVL
       JEQ  ENV1A
* No, are we at end of note
       C    *R3,@NTPAUS
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
ENV2   LI   R5,RATES1
       JMP  ADSR

*
* Envelope 3
* Attack, Release
*
ENV3   LI   R5,RATES2
       JMP  ADSR

*
* Envelope 4
* Attack, Sustain, Release
*
ENV4   LI   R5,RATES3
       JMP  ADSR

*
* Envelope 5
* Attack, Decay, Sustain, Release
*
ENV5   LI   R5,RATES4
       JMP  ADSR

*
* Attack, Decay, Sustain, Release
*
ADSR
* Is this a rest?
       CB   *R2,@RESTVL
       JNE  ADSR1
* Yes, turn off volume
       MOVB @NOVOL,*R4
       RT
* Is this the begining of a note?
ADSR1  MOV  @SNDELP(R1),R7
       JNE  ADSR2
* Yes, set mode to attack
       LI   R6,MDATCK*>100
       MOVB R6,@SNDMOD(R1)
* Start volume at silent
       MOVB @NOVOL,*R4
ADSR2
* Go to mode method.
       MOVB @SNDMOD(R1),R6
       SRL  R6,8
       SLA  R6,1
       AI   R6,DOSTAG
       MOV  *R6,R6
       B    *R6

DOSTAG DATA DOATCK,DODECY,DOSSTN,DORELS

* R5 contains address of current rate
DOATCK SB   *R5,*R4
       JGT  DOA1
       SB   *R4,*R4
       AB   @ONE,@SNDMOD(R1)
DOA1   RT

* R5 contains address of current rate
DODECY AB   @1(R5),*R4
       CB   *R4,@2(R5)
       JLT  DOD1
       MOVB @2(R5),*R4
       AB   @ONE,@SNDMOD(R1)
DOD1   RT

* R5 contains address of current rate
DOSSTN MOVB @2(R5),*R4
* the above line of code is for just incase someone
* switched envelopes mid-note
       MOVB @3(R5),R6
       SRL  R6,8
       C    *R3,R6
       JH   DOS1
       AB   @ONE,@SNDMOD(R1)
DOS1   RT

* R5 contains address of current rate
DORELS AB   @4(R5),*R4
       CB   *R4,@NOVOL
       JLE  DOR1
       MOVB @NOVOL,*R4
DOR1   RT

D      EQU  15      * Mode Disabled
* byte 0 = attack rate
* byte 1 = decay rate
* byte 2 = sustain level
* byte 3 = start release when this much time remains
* byte 4 = release rate
RATES1 BYTE D,D,0,16,1
RATES2 BYTE 4,1,D,16,D
RATES3 BYTE 4,D,0,16,1
RATES4 BYTE 4,1,8,8,1
  
*
* Envelope 6
* Attacks for awhile, instantly return to mid-level, repeat
*
ENV6
* Is this a rest?
       CB   *R2,@RESTVL
       JEQ  ENV6A
* No, are we at end of note
       C    *R3,@NTPAUS
       JH   ENV6B
* Yes, turn off sound
ENV6A  MOVB @NOVOL,*R4
       RT
* No, set volume acording to remaining time
ENV6B  MOV  *R3,R5
       ANDI R5,7
       SLA  R5,8
       MOVB R5,*R4
       RT

*
* Envelope 7
* Goes up and down by 8 position repeatedly
*
ENV7
* Is this a rest?
       CB   *R2,@RESTVL
       JEQ  ENV7A
* No, are we at end of note
       C    *R3,@NTPAUS
       JH   ENV7B
* Yes, turn off sound
ENV7A  MOVB @NOVOL,*R4
       RT
* No, set volume acording to remaining time
ENV7B  MOV  *R3,R5
       ANDI R5,15
       AI   R5,-8
       ABS  R5
       SLA  R5,8
       MOVB R5,*R4
       RT

*
* Envelope 8
* High volume, mid-level volume, repeat
*
ENV8
* Is this a rest?
       CB   *R2,@RESTVL
       JEQ  ENV8A
* No, are we at end of note
       C    *R3,@NTPAUS
       JH   ENV8B
* Yes, turn off sound
ENV8A  MOVB @NOVOL,*R4
       RT
* No, set volume acording to remaining time
ENV8B  MOV  *R3,R5
       ANDI R5,8
* R5 now contains either 0 or 8.
* (top of mid-level volume)
       MOVB @LBR5,*R4
       RT

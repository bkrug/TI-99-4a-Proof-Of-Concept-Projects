# Game Demo Code

The code in this repository is not code for an actual game, but proof-of-concept code. The goal is to make a side-scrolling platformer for a TI-99/4a and to write it in assembly language (CPU is TMS9900). The ".TXT" documents in this repository are assembly language programs in which I attempt to learn some sort of game related concept.

## PAGEFLIP
Page flipping is a pretty basic concept for game development. This miniture program writes two text messages in two different locations in the computer's VDP RAM. Then the program writes to a VDP register once per second to redefine the address of the Screen Image Table. The running program thus displays two different text messages that switch each second. This is not impressive animation, but it demonstrates how page flipping is done on this particular system.

## KEYSCAN
Normally when you write in assembly on a TI-99, you detect user input through Editor/Assembler's KSCAN routine or through the console's SCAN routine.
There some reasons why many assembly programmers are dissatisfied with these routines.
The TI-99 only had 256 bytes of "scratch pad" memory. This was the fastest memory on the system.
The KSCAN and SCAN routine use up at least 36 bytes of that 256 bytes.
Additionally, KSCAN and SCAN don't seem ideal for detecting when the user is holding down two keys at once.
Detecting that can be useful when a game is designed for keyboard play.
Therefore, many assembly language hobbyists try to write there own keyboard scanning methods.
KEYSCAN demostrates detecting key presses through the CRU and bypassing the SCAN routine.

## HSCROLL, HSCROLLDAT, FIXEDAT
This set of programs are meant to be loaded together.
They are an attempt at horizontal scrolling.
The TI's video chip does not have any support for hardware scrolling,
so smooth scrolling could only be achieved by redfining character patterns.
HSCROLL is my own mehtod for doing this.
HSCROLL defines 10 sets of 8 characters.
In each set, each character's pattern is shifted one pixel relative to another character in the set.
Scrolling is achieved not by editing the pattern table, but by switching which characters are displayed in the screen image table.
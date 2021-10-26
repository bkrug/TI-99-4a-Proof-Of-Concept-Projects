This scrolling experiment is faster than earlier attempts.
Besides storing the current screen in the VDP RAM, it also stores the next screen to the left and the right.
If a player scrolls 8-pixels to the right (no faster than one pixel per VDP interrupt),
then the right screen becomes the current screen, the old current screen becomes the left screen, and the program has 8 VDP interrupts during which it can write the new right screen to VDP RAM.
It writes the new screen 4 rows at a time, so it takes 6 VDP interrupts at most.
Between each VDP interrupt there is plenty of time to do other logic besides writing characters to a screen description table.

Older Scrolling logic had the bug that you could hear the music slow down when the player moved too fast.
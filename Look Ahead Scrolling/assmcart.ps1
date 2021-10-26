# Run this script with XAS99 to assemble all files
# See https://endlos99.github.io/xdt99/
#
# If you can't run powershell scripts research this command locally:
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Assemble the files
write-host 'Assembling SCROLL.asm'
xas99.py -S -R -b SCROLL.asm -o scrollC.bin -L scroll.lst
# Run this script with XAS99 to assemble all files
# See https://endlos99.github.io/xdt99/
#
# If you can't run powershell scripts research this command locally:
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Assemble the files
$file = "SPEED.asm"
write-host 'Assembling' $file.Name
$listFile = $file.Name.Replace(".asm", "") + ".lst"
xas99.py -q -S -R $file.Name -L $listFile

# Add TIFILES header to all object files
$objectFile = "SPEED.obj"
xdm99.py -T $objectFile.Name -f DIS/FIX80 -o $objectFile.Name
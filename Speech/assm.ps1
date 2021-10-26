# Run this script with XAS99 to assemble all files
# See https://endlos99.github.io/xdt99/
#
# If you can't run powershell scripts research this command locally:
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Assemble the files
$files = Get-ChildItem ".\" -Filter *.asm |
         Where-Object { $_.Name -ne 'LOADTSTS.asm' }
ForEach($file in $files) {
    write-host 'Assembling' $file.Name
    $listFile = $file.Name.Replace(".asm", "") + ".lst"
    xas99.py -q -S -R $file.Name -L $listFile
}

# Add TIFILES header to all object files
$objectFiles = Get-ChildItem ".\" -Filter *.obj |
               Where-Object { $_.Name -ne 'ARRAY.obj' -and $_.Name -ne 'MEMBUF.obj' }
ForEach($objectFile in $objectFiles) {
    xdm99.py -T $objectFile.Name -f DIS/FIX80 -o $objectFile.Name
}
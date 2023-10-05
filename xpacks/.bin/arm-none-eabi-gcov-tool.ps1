#!/usr/bin/env pwsh
$basedir=Split-Path $MyInvocation.MyCommand.Definition -Parent

$exe=""
if ($PSVersionTable.PSVersion -lt "6.0" -or $IsWindows) {
  # Fix case when both the Windows and Linux builds of Node
  # are installed in the same directory
  $exe=".exe"
}
# Support pipeline input
if ($MyInvocation.ExpectingInput) {
  $input | & "C:/Users/roryw/AppData/Roaming/xPacks/@xpack-dev-tools/arm-none-eabi-gcc/11.2.1-1.1.1/.content/bin/arm-none-eabi-gcov-tool.exe"   $args
} else {
  & "C:/Users/roryw/AppData/Roaming/xPacks/@xpack-dev-tools/arm-none-eabi-gcc/11.2.1-1.1.1/.content/bin/arm-none-eabi-gcov-tool.exe"   $args
}
exit $LASTEXITCODE

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
  $input | & "C:/Users/roryw/AppData/Roaming/xPacks/@xpack-dev-tools/windows-build-tools/4.3.0-1.1/.content/bin/mkdir.exe"   $args
} else {
  & "C:/Users/roryw/AppData/Roaming/xPacks/@xpack-dev-tools/windows-build-tools/4.3.0-1.1/.content/bin/mkdir.exe"   $args
}
exit $LASTEXITCODE

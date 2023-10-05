@ECHO off
GOTO start
:find_dp0
SET dp0=%~dp0
EXIT /b
:start
SETLOCAL
CALL :find_dp0
"C:\Users\roryw\AppData\Roaming\xPacks\@xpack-dev-tools\windows-build-tools\4.3.0-1.1\.content\bin\make.exe"   %*

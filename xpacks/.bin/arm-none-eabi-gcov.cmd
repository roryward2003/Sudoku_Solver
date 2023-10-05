@ECHO off
GOTO start
:find_dp0
SET dp0=%~dp0
EXIT /b
:start
SETLOCAL
CALL :find_dp0
"C:\Users\roryw\AppData\Roaming\xPacks\@xpack-dev-tools\arm-none-eabi-gcc\11.2.1-1.1.1\.content\bin\arm-none-eabi-gcov.exe"   %*

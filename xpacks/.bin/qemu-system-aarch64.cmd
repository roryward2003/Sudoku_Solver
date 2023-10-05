@ECHO off
GOTO start
:find_dp0
SET dp0=%~dp0
EXIT /b
:start
SETLOCAL
CALL :find_dp0
"C:\Users\roryw\AppData\Roaming\xPacks\@xpack-dev-tools\qemu-arm\7.0.0-1.1\.content\bin\qemu-system-aarch64.exe"   %*

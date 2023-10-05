@ECHO off
GOTO start
:find_dp0
SET dp0=%~dp0
EXIT /b
:start
SETLOCAL
CALL :find_dp0

IF EXIST "/bin/sh.exe" (
  SET "_prog=/bin/sh.exe"
) ELSE (
  SET "_prog=/bin/sh"
  SET PATHEXT=%PATHEXT:;.JS;=;%
)

endLocal & goto #_undefined_# 2>NUL || title %COMSPEC% & "%_prog%"  C:\Users\roryw\AppData\Roaming\xPacks\@xpack-dev-tools\arm-none-eabi-gcc\11.2.1-1.1.1\.content\bin\arm-none-eabi-gdb-add-index %*

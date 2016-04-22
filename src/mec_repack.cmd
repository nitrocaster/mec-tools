@echo off
rem Script to fix firmware checksums and re-encrypt
rem Run on a decrypted firmware image

setlocal
setlocal enabledelayedexpansion

set invalid_usage=0
if [%1]==[] set invalid_usage=1
if [%2]==[] set invalid_usage=1
if not [%3]==[] set invalid_usage=1
if !invalid_usage!==1 (
  goto print_usage
)

echo building %2 from %1
mec_csum boot -f %1
mec_csum flasher -f %1
mec_encrypt -e %1 %2
mec_csum outer -f %2
echo.
echo reverifying
set tmp=%2.tmp
mec_csum outer -c %2
mec_encrypt -d %2 %tmp%
mec_csum flasher -c %tmp%
mec_csum boot -c %tmp%
del %tmp%
goto ret

:print_usage
echo usage: %0 ^<input^> ^<output^>
:ret
endlocal

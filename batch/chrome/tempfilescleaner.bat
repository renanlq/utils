@echo off
cd C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default
set count=0
for %%o in (*.tmp) do ( 
	set /A count=count + 1 
)
echo %count%
if %count%==0 (echo "no temporary files") else (del "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\*.tmp" /f /q)
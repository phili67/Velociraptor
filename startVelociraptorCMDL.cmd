rem @echo off

SET mypath=%cd%


rem powershell -executionpolicy bypass -noexit -file "%mypath%\velociraptor.ps1" %1 %2

rem start powershell.exe -WindowStyle Hidden ".\Velociraptor.ps1" %1 %2 

start powershell.exe ".\Velociraptor.ps1" %1 %2 

exit

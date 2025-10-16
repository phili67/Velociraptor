rem @echo off

SET mypath=%cd%

rem en powershell 2.0 et plus, il est possible de cacher la fenêtre console
rem powershell.exe -WindowStyle Hidden .\Velociraptor.ps1 -g

rem en powershell 1.0 on ne peut cacher la console
start powershell.exe .\Velociraptor.ps1 -g

exit

@echo off
pushd .\Source\
del ..\Installer\LuxMax-Release.zip
..\7z a -tzip ..\Installer\LuxMax-Release.zip *
pause
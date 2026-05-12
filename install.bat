@echo off
:: ======================================================
:: AUTOMATISCH NAAR ADMINISTRATOR FORCEEREN
:: ======================================================
:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (shift & goto gotPrivileges)
echo Bezig met aanvragen van Administrator-rechten...
setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
echo UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs"
exit /B

:gotPrivileges
setlocal & pushd %~dp0

:: ======================================================
:: STAP 1: VC++ Redistributables (Essentieel voor WampServer)
:: ======================================================
echo ======================================================
echo STAP 1: VC++ Packs voor WampServer
echo ======================================================
winget install --id Microsoft.VCRedist.2005.x86 -e --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.VCRedist.2005.x64 -e --accept-package-agreements
winget install --id Microsoft.VCRedist.2008.x86 -e --accept-package-agreements
winget install --id Microsoft.VCRedist.2008.x64 -e --accept-package-agreements
winget install --id Microsoft.VCRedist.2010.x86 -e --accept-package-agreements
winget install --id Microsoft.VCRedist.2010.x64 -e --accept-package-agreements
winget install --id Microsoft.VCRedist.2012.x86 -e --accept-package-agreements
winget install --id Microsoft.VCRedist.2012.x64 -e --accept-package-agreements
winget install --id Microsoft.VCRedist.2013.x86 -e --accept-package-agreements
winget install --id Microsoft.VCRedist.2013.x64 -e --accept-package-agreements
winget install --id Microsoft.VCRedist.2015+.x86 -e --accept-package-agreements
winget install --id Microsoft.VCRedist.2015+.x64 -e --accept-package-agreements

echo.
echo ======================================================
echo STAP 2: Kern-programma's installeren
echo ======================================================
winget install --id Git.Git -e --accept-package-agreements
winget install --id TimKosse.FileZilla.Client -e --accept-package-agreements
winget install --id Microsoft.VisualStudio.2022.Community -e --accept-package-agreements
winget install --id Microsoft.VisualStudioCode -e --accept-package-agreements
winget install --id Notepad++.Notepad++ -e --accept-package-agreements

echo.
echo ======================================================
echo STAP 3: Snelkoppelingen maken
echo ======================================================
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%userprofile%\Desktop\PROJECTEN.lnk');$s.TargetPath='http://localhost/';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%userprofile%\Desktop\DATABASE.lnk');$s.TargetPath='http://localhost/phpmyadmin/';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%userprofile%\Desktop\PIXLR.lnk');$s.TargetPath='https://pixlr.com/nl/editor/';$s.Save()"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%userprofile%\Desktop\GITHUB.lnk');$s.TargetPath='https://github.com/';$s.Save()"


echo Snelkoppelingen aangemaakt op je bureaublad.

:: ======================================================
:: STAP 4: KEUZEMENU
:: ======================================================
:menu
cls
echo ======================================================
echo         INSTALLATIE VOLTOOID - WAT WIL JE DOEN?
echo ======================================================
echo.
echo [1] Naar GitHub.com (Account aanmaken)
echo [2] PC Nu herstarten (Aanbevolen voor WampServer)
echo [3] Script afsluiten (Exit)
echo.
set /p choice="Maak een keuze (1, 2 of 3): "

if "%choice%"=="1" goto github
if "%choice%"=="2" goto restart
if "%choice%"=="3" goto end
goto menu

:github
start https://github.com/join
goto menu

:restart
echo PC wordt herstart...
shutdown /r /t 5
exit

:end
echo Succes met je projecten, Patrick!
pause
exit
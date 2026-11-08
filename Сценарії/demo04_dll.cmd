@echo off
chcp 65001 > nul
rem ============================================================
rem  Демо 4. Той самий модуль - у DLL.
rem  Потрібен dumpbin: сценарій сам викличе vcvars64.bat,
rem  або запустіть його з Developer Command Prompt for VS.
rem  До показу спрогнозуйте: що буде з Demo4_app.exe без journal.dll?
rem ============================================================
set "BIN=%~dp0..\x64\Debug"
if not exist "%BIN%\Demo4_app.exe" ( echo [!] Зберіть рішення в конфігурації Debug. & exit /b 1 )
if not exist "%BIN%\journal.dll" ( echo [!] Немає journal.dll: зберіть рішення в конфігурації Debug. & exit /b 1 )
where dumpbin > nul 2> nul || call :vcvars
where dumpbin > nul 2> nul || ( echo [!] Не знайдено dumpbin. Запустіть сценарій з Developer Command Prompt for VS. & exit /b 1 )
cd /d "%BIN%"

echo ^> Demo4_app.exe
.\Demo4_app.exe
pause
echo.
echo ^> dir journal.* Demo4_app.exe
dir journal.dll journal.lib Demo4_app.exe | findstr /i /c:"journal." /c:"Demo4_app."
pause
echo.
echo ^> dumpbin /exports journal.dll
dumpbin /nologo /exports journal.dll | findstr /c:"number of names" /c:"ordinal hint" /c:" average" /c:" best" /c:" print_record" /c:" grade"
echo   grade не експортовано: static.
pause
echo.
echo ^> dumpbin /imports Demo4_app.exe
dumpbin /nologo /imports Demo4_app.exe | findstr /r /c:"^ *journal.dll$" /c:" average$" /c:" best$" /c:" print_record$"
echo.
echo ^> dumpbin /dependents Demo4_app.exe
dumpbin /nologo /dependents Demo4_app.exe | findstr /i /c:".dll"
pause
echo.
echo === Без journal.dll ===
echo   Прогноз: Demo4_app.exe не змінювали. Що буде, якщо journal.dll поруч немає?
pause
ren journal.dll journal.dll.off
echo ^> Demo4_app.exe
.\Demo4_app.exe
echo   exit code %errorlevel%
ren journal.dll.off journal.dll
echo.
echo   -1073741515 = 0xC0000135 = STATUS_DLL_NOT_FOUND. main не почала виконуватися.
pause
exit /b 0

:vcvars
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" exit /b 1
set "PATH=%PATH%;%ProgramFiles(x86)%\Microsoft Visual Studio\Installer"
for /f "usebackq delims=" %%i in (`"%VSWHERE%" -latest -property installationPath`) do set "VSDIR=%%i"
if exist "%VSDIR%\VC\Auxiliary\Build\vcvars64.bat" call "%VSDIR%\VC\Auxiliary\Build\vcvars64.bat" > nul
exit /b 0

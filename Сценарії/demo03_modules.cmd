@echo off
chcp 65001 > nul
rem ============================================================
rem  Демо 3. Програма з двох модулів: компілятор і лінкер окремо.
rem  Потрібен компілятор cl: сценарій сам викличе vcvars64.bat,
rem  або запустіть його з Developer Command Prompt for VS.
rem  До показу спрогнозуйте: що скаже лінкер, якщо дати йому лише main.obj?
rem ============================================================
set "BIN=%~dp0..\x64\Debug"
set "SRC=%~dp0..\Demo3_modules"
if not exist "%BIN%\Demo3_modules.exe" ( echo [!] Зберіть рішення в конфігурації Debug. & exit /b 1 )
where cl > nul 2> nul || call :vcvars
where cl > nul 2> nul || ( echo [!] Не знайдено cl. Запустіть сценарій з Developer Command Prompt for VS. & exit /b 1 )

echo ^> Demo3_modules.exe
"%BIN%\Demo3_modules.exe"
pause

if exist "%~dp0build" rd /s /q "%~dp0build"
md "%~dp0build"
cd /d "%~dp0build"
echo.
echo === Крок 1. Компілятор: кожен .c - окремо, у свій .obj ===
echo ^> cl /c main.c journal.c
cl /nologo /c /utf-8 /W4 "%SRC%\main.c" "%SRC%\journal.c"
dir /b *.obj
pause
echo.
echo ^> dumpbin /symbols main.obj
dumpbin /nologo /symbols main.obj | findstr /r /c:"| print_record$" /c:"| best$" /c:"| average$"
echo   UNDEF - ім'я використано в main.c, але коду тут немає.
pause
echo.
echo ^> dumpbin /symbols journal.obj
dumpbin /nologo /symbols journal.obj | findstr /r /c:"| grade$" /c:"| print_record$" /c:"| best$" /c:"| average$"
echo   External - ім'я видно іншим модулям. Static - лише в journal.c.
pause
echo.
echo === Крок 2. Лінкер збирає .obj в один .exe ===
echo   Прогноз: що скаже лінкер, якщо дати йому лише main.obj?
pause
echo ^> link main.obj
link /nologo main.obj /out:journal.exe
pause
echo.
echo ^> link main.obj journal.obj
link /nologo main.obj journal.obj /out:journal.exe && echo   journal.exe зібрано
pause
echo.
echo === Та сама функція у двох модулях ===
echo   Копія journal.c під іншим ім'ям: усі функції - вдруге.
echo   Прогноз: на яку з них лінкер поскаржиться? А на grade?
pause
copy "%SRC%\journal.c" copy.c > nul
echo ^> cl /c copy.c
cl /nologo /c /utf-8 /W4 /I "%SRC%" copy.c
echo ^> link main.obj journal.obj copy.obj
link /nologo main.obj journal.obj copy.obj /out:journal.exe
echo.
echo   grade - static у кожному файлі, тому двох grade лінкер не бачить.
pause
exit /b 0

:vcvars
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" exit /b 1
set "PATH=%PATH%;%ProgramFiles(x86)%\Microsoft Visual Studio\Installer"
for /f "usebackq delims=" %%i in (`"%VSWHERE%" -latest -property installationPath`) do set "VSDIR=%%i"
if exist "%VSDIR%\VC\Auxiliary\Build\vcvars64.bat" call "%VSDIR%\VC\Auxiliary\Build\vcvars64.bat" > nul
exit /b 0

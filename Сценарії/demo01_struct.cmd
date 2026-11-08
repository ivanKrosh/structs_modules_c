@echo off
chcp 65001 > nul
rem ============================================================
rem  Демо 1. struct: запис з кількох полів.
rem  До показу спрогнозуйте: скільки байтів займає Record = char[10] + int?
rem ============================================================
set "BIN=%~dp0..\x64\Debug"
if not exist "%BIN%\Demo1_struct.exe" ( echo [!] Зберіть рішення в конфігурації Debug. & exit /b 1 )
echo   Прогноз: copy = r; copy.mark = 0; - що стане з r.mark?
echo            sizeof(Record) для char name[10] + int mark - скільки байтів?
pause
echo.
echo ^> Demo1_struct.exe
"%BIN%\Demo1_struct.exe"
echo.
echo   16, а не 14: поле mark (int) починається з адреси, кратної 4, тому після name - 2 порожні байти.
pause

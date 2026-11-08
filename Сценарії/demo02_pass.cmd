@echo off
chcp 65001 > nul
rem ============================================================
rem  Демо 2. Структура у функції: копія чи адреса.
rem  До показу спрогнозуйте: що надрукує print_record після add_bonus_copy?
rem ============================================================
set "BIN=%~dp0..\x64\Debug"
if not exist "%BIN%\Demo2_pass.exe" ( echo [!] Зберіть рішення в конфігурації Debug. & exit /b 1 )
echo   Прогноз: Melnyk 45. Після add_bonus_copy(r) - скільки? Після add_bonus(^&r) - скільки?
pause
echo.
echo ^> Demo2_pass.exe
"%BIN%\Demo2_pass.exe"
pause
echo.
echo === Лабораторна 3: GlobalMemoryStatusEx без dwLength ===
echo   Прогноз: що поверне функція, якщо поле dwLength лишити нулем?
pause
echo ^> Demo2_pass.exe nolength
"%BIN%\Demo2_pass.exe" nolength | findstr /c:"dwLength" /c:"GlobalMemoryStatusEx"
echo.
echo   87 = ERROR_INVALID_PARAMETER. За dwLength функція дізнається, яку версію структури їй передали.
pause

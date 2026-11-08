# Структура даних. Модульне програмування — демонстрації

Демонстраційні програми до заняття 13 курсу «Системне програмування»
(ВСП «Фаховий коледж інформаційних систем і технологій КНЕУ ім. Вадима Гетьмана»).

Тема заняття: **дані, які належать разом, об'єднуються в структуру, а код, який з ними працює, — у модуль**. Розглядаються оголошення `struct`, масив структур і `typedef`, розмір структури та вирівнювання, передача структури у функцію за значенням і через вказівник, а також причина, з якої функції WinAPI просять `&st` і поле розміру. Далі програма ділиться на модулі (`.h` + `.c`), окремо працюють компілятор і лінкер, вводиться `static`. Наприкінці той самий модуль перетворюється на DLL.

Усі програми працюють з одним «журналом»: десять записів «прізвище — оцінка». Оцінки ті самі, що в `marks.bin` на занятті 12: `74 58 91 66 45 83 60 97 26 72`.

## Склад рішення

Рішення `Demo_Lecture_13.slnx`: п'ять проєктів на C і тека зі сценаріями командного рядка.

| Проєкт | Файли | Розділ конспекту | Що показує |
|---|---|---|---|
| `Demo1_struct` | `struct.c` | 1 | `struct Record`, ініціалізація, оператор `.`, копіювання структури присвоєнням, масив структур, `typedef`; `sizeof(Record)` = 16, а не 14; `SYSTEMTIME` — така сама структура |
| `Demo2_pass` | `pass.c` | 2 | `add_bonus_copy(r)` змінює копію, `add_bonus(&r)` змінює оригінал; `->`, `const`; розмір структури і вказівника; аргумент `nolength` — `GlobalMemoryStatusEx` без `dwLength` (помилка 87) |
| `Demo3_modules` | `main.c`, `journal.h`, `journal.c` | 3 | програма з двох модулів; include guard; `static char grade(int)` видно лише в `journal.c` |
| `Demo4_journal` | `journal.h`, `journal.c` | 4 | той самий модуль як DLL — `journal.dll` і бібліотека імпорту `journal.lib`; `journal.c` не змінено, змінено лише `journal.h` |
| `Demo4_app` | `main.c` | 4 | той самий `main.c`, підключений до `journal.dll` неявно |

| Сценарій | Порядок на занятті | Програма |
|---|---|---|
| `Сценарії/demo01_struct.cmd` | 1 | `Demo1_struct` |
| `Сценарії/demo02_pass.cmd` | 2 | `Demo2_pass` |
| `Сценарії/demo03_modules.cmd` | 3 | `Demo3_modules`, а також ручне збирання: `cl /c`, `dumpbin /symbols`, `link` |
| `Сценарії/demo04_dll.cmd` | 4 | `Demo4_app` + `journal.dll`: `dumpbin /exports`, `/imports`, `/dependents`, запуск без DLL |

Кожен проєкт показується **один раз**, у порядку номерів. `Demo4_journal` і `Demo4_app` — одна демонстрація з двох проєктів.

Сценарії запускають програми з `x64\Debug\`, тому **зберіть рішення в Debug**.

Сценаріям 3 і 4 потрібні `cl`, `link` і `dumpbin`. Якщо їх немає в `PATH`, сценарій сам знаходить Visual Studio (через `vswhere`) і викликає `vcvars64.bat`. Якщо це не вдалося, запустіть сценарій з **Developer Command Prompt for VS**.

## Як відкрити у Visual Studio

**Що має бути встановлено.** Visual Studio (достатньо Community) з компонентом **«Розробка класичних застосунків на C++»** (Desktop development with C++).

**Крок 1. Відкрити рішення.** Двічі клацнути `Demo_Lecture_13.slnx` або вибрати *File → Open → Project/Solution*.

> Файл рішення збережено в новому форматі `.slnx`. Якщо ваша версія Visual Studio його не відкриває, оновіть її або відкрийте потрібний `.vcxproj` напряму.

**Крок 2. Зібрати.** **Debug** і **x64**, *Build → Build Solution* (Ctrl+Shift+B). `Demo4_app` посилається на проєкт `Demo4_journal` (*References*), тому Visual Studio спершу збирає DLL, а потім програму, і сама передає лінкеру `journal.lib`.

**Крок 3. Запускати.** `Ctrl+F5` запускає без налагоджувача, `F5` — під налагоджувачем. Зручно один раз налаштувати: правою кнопкою на рішенні → *Properties* → *Startup Project* → **Current selection**. Аргументи командного рядка (`nolength` для `Demo2_pass`) задаються в *Properties → Configuration Properties → Debugging → Command Arguments*.

`Demo4_journal` — це DLL, і запустити її не можна. Стартовим проєктом для демонстрації 4 має бути `Demo4_app`.

## Налаштування проєктів

Налаштування ті самі, що в демонстраціях до занять 8–12: `/W4`, `/utf-8`, Debug без *Just My Code* і без *Basic Runtime Checks*.

Відмінності в демонстрації 4:

| Проєкт | Налаштування | Навіщо |
|---|---|---|
| `Demo4_journal` | *Configuration Type* = **Dynamic Library (.dll)** | результат — DLL, а не `.exe` |
| `Demo4_journal` | *Target Name* = `journal` | файл називається `journal.dll`, а не `Demo4_journal.dll` |
| `Demo4_journal` | *Preprocessor Definitions* + `JOURNAL_EXPORTS` | у `journal.h` макрос `JOURNAL_API` стає `__declspec(dllexport)` |
| `Demo4_app` | *Additional Include Directories* = `$(SolutionDir)Demo4_journal` | `#include "journal.h"` знаходить заголовок DLL |
| `Demo4_app` | *References* → `Demo4_journal` | порядок збирання і `journal.lib` для лінкера |

Обидва проєкти записують результат у спільну теку `x64\Debug`, тому `journal.dll` лежить поруч із `Demo4_app.exe`.

## Як зібрати з командного рядка

**Developer Command Prompt for VS**, з кореня репозиторію:

```
msbuild Demo_Lecture_13.slnx /p:Configuration=Debug /p:Platform=x64
```

Окремі файли:

```
cl /nologo /utf-8 /W4 Demo1_struct\struct.c                                -> struct.exe
cl /nologo /utf-8 /W4 Demo3_modules\main.c Demo3_modules\journal.c         -> main.exe
```

DLL і програма до неї:

```
cl /nologo /utf-8 /W4 /LD /DJOURNAL_EXPORTS Demo4_journal\journal.c /Fe:journal.dll
cl /nologo /utf-8 /W4 /I Demo4_journal Demo4_app\main.c journal.lib
```

## Як запускати без сценаріїв

З теки `x64\Debug`:

```
Demo1_struct.exe
Demo2_pass.exe
Demo2_pass.exe nolength
Demo3_modules.exe
Demo4_app.exe                      journal.dll має лежати поруч
```

## Відомі граблі

**`'vswhere.exe' is not recognized` або `[!] Не знайдено cl`.** Сценарій 3 або 4 не знайшов Visual Studio. Запустіть його з *Developer Command Prompt for VS* (меню Пуск → Visual Studio → Developer Command Prompt).

**Сценарій 3 показує `error LNK2019` і `error LNK2005`.** Це запланований результат: сценарій навмисно дає лінкеру спершу лише `main.obj`, а потім дві копії модуля. Збирання у Visual Studio від цього не ламається, бо сценарій працює в окремій теці `Сценарії\build`, яку git ігнорує.

**Сценарій 4 без `journal.dll` показує вікно *System Error*.** Це запланований результат: Windows не знайшла DLL і не запустила програму. Натисніть OK. Сценарій одразу повертає `journal.dll` на місце. Якщо його перервали раніше, перейменуйте `x64\Debug\journal.dll.off` назад на `journal.dll` або зберіть рішення ще раз.

**`Demo4_journal` не запускається через F5 («is not a valid Win32 application» або запит на вибір програми).** DLL не запускають. Виберіть стартовим проєктом `Demo4_app`.

**`dumpbin /exports` показує `average = @ILT+245(average)`.** Це Debug-збірка з інкрементним компонуванням: `@ILT` — проміжна таблиця переходів. У Release там буде лише ім'я.

**Кодування сценаріїв.** Файли `.cmd` збережено в **UTF-8 з CRLF**. Перший рядок після `@echo off` — `chcp 65001 > nul`.

## Супровідні матеріали

Конспект заняття та презентація зберігаються в навчально-методичному комплексі курсу.

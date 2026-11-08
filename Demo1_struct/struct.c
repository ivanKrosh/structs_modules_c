#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stddef.h>
#include <windows.h>

struct Record {                        /* опис типу: пам'ять ще не виділено */
    char name[10];
    int  mark;
};

typedef struct Record Record;          /* далі можна писати просто Record */

int main(void)
{
    struct Record r = { "Bondar", 74 };
    printf("r:    %s %d\n", r.name, r.mark);

    Record copy = r;                   /* копіюються всі поля, і масив name теж */
    copy.mark = 0;
    printf("copy: %s %d   r: %s %d\n", copy.name, copy.mark, r.name, r.mark);

    Record journal[] = {
        { "Bondar",    74 }, { "Hnatiuk",   58 }, { "Kovalenko", 91 },
        { "Lysenko",   66 }, { "Melnyk",    45 }, { "Petrenko",  83 },
        { "Savchuk",   60 }, { "Tkachenko", 97 }, { "Shevchuk",  26 },
        { "Yurchenko", 72 }
    };
    int n = sizeof journal / sizeof journal[0];

    printf("\njournal: %d records\n", n);
    for (int i = 0; i < n; i++)
        printf("%2d  %-10s %3d\n", i, journal[i].name, journal[i].mark);

    printf("\nsizeof(Record) = %zu, offsetof(Record, mark) = %zu\n",
           sizeof(Record), offsetof(Record, mark));
    printf("sizeof journal = %zu\n", sizeof journal);

    SYSTEMTIME st;                     /* структура з windows.h */
    GetLocalTime(&st);
    printf("\nSYSTEMTIME: %02u.%02u.%u, sizeof = %zu\n",
           st.wDay, st.wMonth, st.wYear, sizeof st);
    return 0;
}

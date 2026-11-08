#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>
#include <windows.h>

typedef struct Record {
    char name[10];
    int  mark;
} Record;

void add_bonus_copy(Record r)          /* отримує копію запису */
{
    r.mark += 10;
    printf("  inside add_bonus_copy: %d\n", r.mark);
}

void add_bonus(Record *r)              /* отримує адресу запису */
{
    r->mark += 10;                     /* те саме, що (*r).mark += 10 */
}

void print_record(const Record *r)     /* const: функція лише читає */
{
    printf("  %-10s %3d\n", r->name, r->mark);
}

int main(int argc, char *argv[])
{
    Record r = { "Melnyk", 45 };
    print_record(&r);

    add_bonus_copy(r);
    printf("after add_bonus_copy:\n");
    print_record(&r);

    add_bonus(&r);
    printf("after add_bonus:\n");
    print_record(&r);

    printf("\nsizeof(Record) = %zu, sizeof(Record *) = %zu\n",
           sizeof(Record), sizeof(Record *));
    printf("sizeof(WIN32_FIND_DATAA) = %zu\n", sizeof(WIN32_FIND_DATAA));

    MEMORYSTATUSEX ms = { 0 };
    if (argc < 2 || strcmp(argv[1], "nolength") != 0)
        ms.dwLength = sizeof ms;       /* розмір структури - до виклику */
    printf("\ndwLength = %lu\n", ms.dwLength);
    if (!GlobalMemoryStatusEx(&ms)) {
        printf("GlobalMemoryStatusEx: FALSE, error %lu\n", GetLastError());
        return 1;
    }
    printf("GlobalMemoryStatusEx: TRUE, load %lu%%, total %.1f GB\n",
           ms.dwMemoryLoad, ms.ullTotalPhys / 1073741824.0);
    return 0;
}

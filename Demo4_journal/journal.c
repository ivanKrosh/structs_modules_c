#include <stdio.h>
#include "journal.h"

static char grade(int mark)            /* видна лише в цьому файлі */
{
    if (mark >= 90) return 'A';
    if (mark >= 82) return 'B';
    if (mark >= 74) return 'C';
    if (mark >= 64) return 'D';
    if (mark >= 60) return 'E';
    return 'F';
}

void print_record(const Record *r)
{
    printf("%-10s %3d  %c\n", r->name, r->mark, grade(r->mark));
}

const Record *best(const Record *j, int n)
{
    const Record *b = &j[0];
    for (int i = 1; i < n; i++)
        if (j[i].mark > b->mark)
            b = &j[i];
    return b;
}

double average(const Record *j, int n)
{
    int sum = 0;
    for (int i = 0; i < n; i++)
        sum += j[i].mark;
    return (double)sum / n;
}

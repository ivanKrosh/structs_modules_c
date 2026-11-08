#include <stdio.h>
#include "journal.h"

int main(void)
{
    Record journal[] = {
        { "Bondar",    74 }, { "Hnatiuk",   58 }, { "Kovalenko", 91 },
        { "Lysenko",   66 }, { "Melnyk",    45 }, { "Petrenko",  83 },
        { "Savchuk",   60 }, { "Tkachenko", 97 }, { "Shevchuk",  26 },
        { "Yurchenko", 72 }
    };
    int n = sizeof journal / sizeof journal[0];

    for (int i = 0; i < n; i++)
        print_record(&journal[i]);

    printf("\nbest:    ");
    print_record(best(journal, n));
    printf("average: %.1f\n", average(journal, n));
    return 0;
}

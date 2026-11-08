#ifndef JOURNAL_H
#define JOURNAL_H

#ifdef JOURNAL_EXPORTS                 /* визначено лише в проєкті DLL */
#define JOURNAL_API __declspec(dllexport)
#else
#define JOURNAL_API __declspec(dllimport)
#endif

typedef struct Record {
    char name[10];
    int  mark;
} Record;

JOURNAL_API void          print_record(const Record *r);
JOURNAL_API const Record *best(const Record *j, int n);
JOURNAL_API double        average(const Record *j, int n);

#endif

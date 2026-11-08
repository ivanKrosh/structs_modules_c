#ifndef JOURNAL_H
#define JOURNAL_H

typedef struct Record {
    char name[10];
    int  mark;
} Record;

void          print_record(const Record *r);
const Record *best(const Record *j, int n);
double        average(const Record *j, int n);

#endif

#include "biblio.h"

char buffer[256];
char fmt[] = "Mover disco _ da torre _ para a torre _\0";

void _start() {
  torre_de_hanoi(atoi(gets(buffer)), 'A', 'B', 'C', fmt);
  exit(0);
}

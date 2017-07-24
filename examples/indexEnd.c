#include <stdio.h>

int main ( int argc, char** argv) {
    printf("Loop iterator test\n");
    unsigned int i;
    unsigned int n = 28;
    for (i=0; i < (n & ~ 3); i++) {
      printf("i = %d\n", i);
      printf("n & ~3 = %d\n", n & ~3);
    }
    printf("end\n");
}

#include <stdio.h>
#include <arm_neon.h>

#define R_TO_Y (65.738)
#define G_TO_Y (129.057)
#define B_TO_Y (25.064)
#define R_TO_CB (36.945)
#define G_TO_CB (74.494)
#define B_TO_CB (112.439)
#define R_TO_CR (112.439)
#define G_TO_CR (94.154)
#define B_TO_CR (18.285)

void add_ints(char ** __restrict Y, char ** __restrict Cb, char ** __restrict Cr, char ** __restrict R, char ** __restrict G, char ** __restrict B, unsigned int nrows, unsigned int ncols)
{
    unsigned int i;
    unsigned int j;

    for(i = 0; i < (nrows & ~3); i++) {
        for(j = 0; j < (ncols & ~3); j++) {
            Y[i][j] = 16 + (R_TO_Y * R[i][j] + G_TO_Y * G[i][j] + B_TO_Y * B[i][j]);
            Cb[i][j] = 128 + (R_TO_CB * R[i][j] + G_TO_CB * G[i][j] + B_TO_CB * B[i][j]);
            Cr[i][j] = 128 + (R_TO_CR * R[i][j] + G_TO_CR * G[i][j] + B_TO_CR * B[i][j]);
        }
    }
}

int main( int argc, char** argv) {
    printf("Vectorization test\n");
    return (0);
}

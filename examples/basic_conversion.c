#include <stdio.h>
#include <math.h>
/* #include <arm_neon.h> */

#define R_TO_Y (65.738)
#define G_TO_Y (129.057)
#define B_TO_Y (25.064)
#define R_TO_CB (-37.945)
#define G_TO_CB (-74.494)
#define B_TO_CB (112.439)
#define R_TO_CR (112.439)
#define G_TO_CR (-94.154)
#define B_TO_CR (-18.285)
#define Y_NORM_FACTOR (256)
#define pixel_odd (pixel_even + ncols)

void add_ints(char * __restrict Y, char * __restrict Cb, char * __restrict Cr, char * __restrict data, unsigned int nrows, unsigned int ncols)
{
    unsigned int row = 0;
    unsigned int col;
    unsigned int i_even = 0;
    unsigned int i_odd = ncols*3;
    unsigned int pixel = 0;
    unsigned int pixel_even = 0;
    while(row < nrows) {
      col = 0;
      while(col < ncols) {
        unsigned char R_even, G_even, B_even, R_odd, G_odd, B_odd;
        float t_even, t_odd, t_Cb, t_Cr;
        // pixel 1
        R_even = data[i_even++];
        G_even = data[i_even++];
        B_even = data[i_even++];
        t_even = 16 + (R_TO_Y * R_even + G_TO_Y * G_even + B_TO_Y * B_even)/Y_NORM_FACTOR;
        Y[pixel_even] = (char) round(t_even > 255 ? 255 : t_even);
        t_Cb = (R_TO_CB * R_even + G_TO_CB * G_even + B_TO_CB * B_even);
        t_Cr = (R_TO_CR * R_even + G_TO_CR * G_even + B_TO_CR * B_even);

        // pixel 3
        R_odd = data[i_odd++];
        G_odd = data[i_odd++];
        B_odd = data[i_odd++];
        t_odd = 16 + (R_TO_Y * R_odd + G_TO_Y * G_odd + B_TO_Y * B_odd)/Y_NORM_FACTOR;
        Y[pixel_odd] = (char) round(t_even > 255 ? 255 : t_odd);
        t_Cb += (R_TO_CB * R_odd + G_TO_CB * G_odd + B_TO_CB * B_odd);
        t_Cr += (R_TO_CR * R_odd + G_TO_CR * G_odd + B_TO_CR * B_odd);

        pixel_even++;
        col++;

        // pixel 2
        R_even = data[i_even++];
        G_even = data[i_even++];
        B_even = data[i_even++];
        t_even = 16 + (R_TO_Y * R_even + G_TO_Y * G_even + B_TO_Y * B_even)/Y_NORM_FACTOR;
        Y[pixel_even] = (char) round(t_even > 255 ? 255 : t_even);
        t_Cb += (R_TO_CB * R_even + G_TO_CB * G_even + B_TO_CB * B_even);
        t_Cr += (R_TO_CR * R_even + G_TO_CR * G_even + B_TO_CR * B_even);

        // pixel 4
        R_odd = data[i_odd++];
        G_odd = data[i_odd++];
        B_odd = data[i_odd++];
        t_odd = 16 + (R_TO_Y * R_odd + G_TO_Y * G_odd + B_TO_Y * B_odd)/Y_NORM_FACTOR;
        Y[pixel_odd] = (char) round(t_odd > 255 ? 255 : t_odd);
        t_Cb += (R_TO_CB * R_odd + G_TO_CB * G_odd + B_TO_CB * B_odd);
        t_Cr += (R_TO_CR * R_odd + G_TO_CR * G_odd + B_TO_CR * B_odd);

        Cb[pixel] = (char) round((128 * 4 + t_Cb/Y_NORM_FACTOR)/4);
        Cr[pixel] = (char) round((128 * 4 + t_Cr/Y_NORM_FACTOR)/4);

        pixel++;
        pixel_even++;
        col++;
      }
      row += 2;
      i_even += ncols*3;
      i_odd += ncols*3;
      pixel_even += ncols;
    }
}

int main( int argc, char** argv) {
  printf("Vectorization test\n");

  unsigned int nrows = 4;
  unsigned int ncols = 4;
  char data[48] = {
    0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,
    0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,
    0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,
    0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,
  };
  char Y[16];
  char Cb[4];
  char Cr[4];
  add_ints(Y, Cb, Cr, data, nrows, ncols);

  int i;
  for(i=0; i < 16; i++){
    printf("Y[%d] = %u\n", i, (unsigned char) Y[i]);
  }
  for(i=0; i < 4; i++){
    printf("Cb[%d] = %u\n", i, (unsigned char) Cb[i]);
  }
  for(i=0; i < 4; i++){
    printf("Cr[%d] = %u\n", i, (unsigned char) Cr[i]);
  }
  return (0);
}

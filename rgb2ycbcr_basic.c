#include <stdlib.h>
#include <stdio.h>
#include <math.h>
/* #include <arm_neon.h> */

#include "bmp_operations.h"

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

void rgb2ycbcr_basic(char * __restrict Y, char * __restrict Cb, char * __restrict Cr, char * __restrict data, unsigned int nrows, unsigned int ncols)
{
    unsigned int row = 0;
    unsigned int col;
    unsigned int i_even = 0;
    unsigned int i_odd = ncols*3 + (ncols & 3);
    unsigned int pixel = 0;
    unsigned int pixel_even = 0;
    while(row < nrows) {
      col = 0;
      while(col < ncols) {
        unsigned char R_even, G_even, B_even, R_odd, G_odd, B_odd;
        float t_even, t_odd, t_Cb, t_Cr;
        B_even = data[i_even++];
        G_even = data[i_even++];
        R_even = data[i_even++];
        t_even = 16 + (R_TO_Y * R_even + G_TO_Y * G_even + B_TO_Y * B_even)/Y_NORM_FACTOR;
        Y[pixel_even] = (char) round(t_even > 255 ? 255 : t_even);
        t_Cb = (R_TO_CB * R_even + G_TO_CB * G_even + B_TO_CB * B_even);
        t_Cr = (R_TO_CR * R_even + G_TO_CR * G_even + B_TO_CR * B_even);

        // pixel 3
        B_odd = data[i_odd++];
        G_odd = data[i_odd++];
        R_odd = data[i_odd++];
        t_odd = 16 + (R_TO_Y * R_odd + G_TO_Y * G_odd + B_TO_Y * B_odd)/Y_NORM_FACTOR;
        Y[pixel_odd] = (char) round(t_even > 255 ? 255 : t_odd);
        t_Cb += (R_TO_CB * R_odd + G_TO_CB * G_odd + B_TO_CB * B_odd);
        t_Cr += (R_TO_CR * R_odd + G_TO_CR * G_odd + B_TO_CR * B_odd);

        pixel_even++;
        col++;

        // pixel 2
        B_even = data[i_even++];
        G_even = data[i_even++];
        R_even = data[i_even++];
        t_even = 16 + (R_TO_Y * R_even + G_TO_Y * G_even + B_TO_Y * B_even)/Y_NORM_FACTOR;
        Y[pixel_even] = (char) round(t_even > 255 ? 255 : t_even);
        t_Cb += (R_TO_CB * R_even + G_TO_CB * G_even + B_TO_CB * B_even);
        t_Cr += (R_TO_CR * R_even + G_TO_CR * G_even + B_TO_CR * B_even);

        // pixel 4
        B_odd = data[i_odd++];
        G_odd = data[i_odd++];
        R_odd = data[i_odd++];
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
      /*
       Bitmap images are aligned after each row
       */
      i_even += ncols*3 + (ncols & 3) + (ncols & 3);
      i_odd += ncols*3 + (ncols & 3) + (ncols & 3);
      pixel_even += ncols;
    }
}

void print_triple_char(char* v1, int v1_size, char* v2, int v2_size, char* v3, int v3_size) {
  int i;
  for(i=0; i < v1_size; i++){
    printf("v1[%d] = %u\n", i, (unsigned char) v1[i]);
  }
  for(i=0; i < v2_size; i++){
    printf("v2[%d] = %u\n", i, (unsigned char) v2[i]);
  }
  for(i=0; i < v3_size; i++){
    printf("v3[%d] = %u\n", i, (unsigned char) v3[i]);
  }
}

int write_raw_image_data(char* filename, char* data, int size) {
  FILE* fp = fopen(filename, "w");
  if(!fp) {
    printf("Error opening file (%s) to write to\n", filename);
    return 0;
  }
  fwrite(data, 1, size, fp);
  fclose(fp);
  return 1;
}

int main( int argc, char** argv) {
  bitmap_image* image;
  if(argc==2) {
    image = bmp_load(argv[1]);
  } else {
    printf("No input image specified");
    return 0;
  }

  unsigned int nrows = image->header.height;
  unsigned int ncols = image->header.width;
  unsigned int npixels = nrows * ncols;
  char data2x4[32] = {
    0x20,0x30,0x40,0x20,0x30,0x40,0x00,0x00,
    0x20,0x30,0x40,0x20,0x30,0x40,0x00,0x00,
    0x20,0x30,0x40,0x20,0x30,0x40,0x00,0x00,
    0x20,0x30,0x40,0x20,0x30,0x40,0x00,0x00,
  };
  /* char data4x4[48] = { */
  /*   0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40, */
  /*   0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40, */
  /*   0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40, */
  /*   0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40,0x20,0x30,0x40, */
  /* }; */

  char* Y = (char*) malloc(npixels);
  char* Cb = (char*) malloc(npixels/4);
  char* Cr = (char*) malloc(npixels/4);

  rgb2ycbcr_basic(Y, Cb, Cr, image->data, nrows, ncols);

  // print_triple_char(Y, npixels, Cb, npixels/4, Cr, npixels/4);

  write_raw_image_data("out_Y", Y, npixels);
  write_raw_image_data("out_Cb", Cb, npixels/4);
  write_raw_image_data("out_Cr", Cr, npixels/4);

  free(Y);
  free(Cb);
  free(Cr);
  return (0);
}

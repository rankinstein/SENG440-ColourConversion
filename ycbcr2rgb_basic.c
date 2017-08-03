#include <stdlib.h>
#include <stdio.h>
#include <math.h>
/* #include <arm_neon.h> */

#include "bmp_operations.h"

#define Y_TO_RGB (1.164)
#define CR_TO_R (1.596)
#define CR_TO_G (-0.813)
#define CB_TO_G (-0.391)
#define CB_TO_B (2.018)
#define Y_NORM_FACTOR (256)

//TODO: TEST ME
unsigned char* upsample(unsigned char* c_small, unsigned int n_small_rows, unsigned int n_small_cols) {
  unsigned int n_big_rows = n_small_rows << 1;
  unsigned int n_big_cols = n_small_cols << 1;
  unsigned char* c_big = malloc(sizeof(char)*n_big_rows*n_big_cols);
  unsigned int row = 0;
  unsigned int col = 0;
  unsigned int small_i;
  unsigned int big_i;

  //Pass 1: interpolate all but last 2 rows and last 2 cols.
  while (row < n_small_rows - 1) {
    col = 0;
    while (col < n_small_cols - 1) {

      small_i = row*n_small_cols + col;
      big_i = (row << 1)*n_big_cols + (col << 1);

      c_big[big_i]                  = c_small[small_i];
      c_big[big_i + 1]              = (c_small[small_i] + c_small[small_i + 1]) >> 1;
      c_big[big_i + n_big_cols]     = (c_small[small_i] + c_small[small_i + n_small_cols]) >> 1;
      c_big[big_i + n_big_cols + 1] = (c_small[small_i] + c_small[small_i + n_small_cols + 1]) >> 1;

      col++;
    }

    row++;
  }

  //Pass 2: interpolate last row, and copy pixes that can't be interpolated
  row = n_small_rows - 1;
  col = 0;
  while (col < n_small_cols - 1) {
    small_i = row*n_small_cols + col;
    big_i   = (row << 1)*n_big_cols + (col << 1);

    c_big[big_i]                  = c_small[small_i];
    c_big[big_i + 1]              = (c_small[small_i] + c_small[small_i + 1]) >> 1;
    c_big[big_i + n_big_cols]     = c_big[big_i] ;
    c_big[big_i + n_big_cols + 1] = c_big[big_i + 1];

    col++;
  }

  //Pass 3: interpolate last column, and copy pixes that can't be interpolated
  row = 0;
  col = n_small_cols - 1;
  while (row < n_small_rows - 1) {
    small_i = row*n_small_cols + col;
    big_i   = (row << 1)*n_big_cols + (col << 1);

    c_big[big_i]                  = c_small[small_i];
    c_big[big_i + 1]              = c_small[small_i];
    c_big[big_i + n_big_cols]     = (c_small[small_i] + c_small[small_i + n_small_cols]) >> 1;
    c_big[big_i + n_big_cols + 1] = c_big[big_i + n_big_cols];

    row++;
  }

  //Pass 4: copy corner values
  small_i = n_small_rows*n_small_cols - 1;
  big_i   = (n_big_rows - 1)*(n_big_cols) - 2;

  c_big[big_i]                  = c_small[small_i];
  c_big[big_i + 1]              = c_small[small_i];
  c_big[big_i + n_big_cols]     = c_small[small_i];
  c_big[big_i + n_big_cols + 1] = c_small[small_i];

  return c_big;
}

//TODO: TEST ME
void convert_ycbcr_to_rgb(unsigned char * __restrict y, unsigned char * __restrict cb, unsigned char * __restrict cr, unsigned char * __restrict rgb, unsigned int nrows, unsigned int ncols)
{
  unsigned int size = nrows*ncols;
  unsigned int row_padding = 2;
  unsigned int rgb_i = 0;
  unsigned int ycc_i = 0;

  while (ycc_i < size) {
    rgb[rgb_i++] = (unsigned char)(Y_TO_RGB*(y[ycc_i] - 16) + CR_TO_R*(cr[ycc_i] - 128));
    rgb[rgb_i++] = (unsigned char)(Y_TO_RGB*(y[ycc_i] - 16) + CR_TO_G*(cr[ycc_i] - 128) + CB_TO_G*(cb[ycc_i] - 128));
    rgb[rgb_i++] = (unsigned char)(Y_TO_RGB*(y[ycc_i] - 16) + CB_TO_B*(cb[ycc_i] - 128));
    ycc_i++;
  }

  printf("while complete\n");

  // unsigned int i;
  // size = size*3;
  // printf("size: %d\n", size);
  // for (i = 0; i < size; i++) {
  //   if (i % 24 == 0) printf("\n");
  //   printf("%x ", rgb[i]);
  //   if (i % 3 == 2) printf("- ");
  // }
  // printf("\n");

}

int write_hex_data(char* filename, unsigned char* data, unsigned int length) {

  FILE* fp = fopen(filename, "wb");
  if (!fp) {
    printf("Unable to open file\n");
    return 1;
  }
  fwrite(data, sizeof(unsigned char), length, fp);
  fclose(fp);
  return 0;
}

//TODO: TEST ME
unsigned char* raw_ycbcr_load(char* filename) {
  FILE* fp = fopen(filename, "rb");
  unsigned char* data;
  long file_size;
  if (!fp) {
    printf("Error opening file (%s) to read\n", filename);
  }
  fseek(fp, 0L, SEEK_END);
  file_size = ftell(fp) + 1;
  rewind(fp);
  data = (unsigned char*)malloc(file_size);
  if(data == NULL) {
    // printf("Error allocating memory\n");
  }
  fread(data, file_size, 1, fp);
  fclose(fp);
  return data;
}

int main( int argc, char** argv) {
  printf("YCbCr to RGB: Simple Conversion\n");
  if (argc != 3) {
    printf("Not enough arguments.  Please provide the WIDTH and HEIGHT of the image\n");
    return 0;
  }

  // unsigned char* y  = raw_ycbcr_load("./input/tiger.bmp");
  // unsigned char* cb = raw_ycbcr_load("")
  // unsigned char* cr = raw_ycbcr_load("")

  //Assumes height and width are positive and less than max signed int value
  unsigned int ncols  = (unsigned int)atoi(argv[1]);
  unsigned int nrows = (unsigned int)atoi(argv[2]);

  unsigned char* rgb = (unsigned char*)malloc(3*sizeof(unsigned char)*nrows*ncols);

  //TODO: save info to header

  unsigned char test_y_data[64] = {
    0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x00,0x99,
    0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x00,0x99,
    0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11,
    0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11,
    0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x00,0x99,
    0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x00,0x99,
    0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11,
    0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11
  };
  unsigned char test_cb_data[16] = {
    0xFF,0xDD,0xBB,0x99,
    0x77,0x55,0x33,0x11,
    0xEE,0xCC,0xAA,0x88,
    0x66,0x44,0x22,0x00
  };
  unsigned char test_cr_data[16] = {
    0xFF,0xDD,0xBB,0x99,
    0x77,0x55,0x33,0x11,
    0xEE,0xCC,0xAA,0x88,
    0x66,0x44,0x22,0x00
  };

  unsigned char* cb_up = malloc(sizeof(unsigned char)*nrows*ncols);
  cb_up = upsample(test_cb_data, nrows >> 1, ncols >> 1);
  unsigned char* cr_up = malloc(sizeof(unsigned char)*ncols*nrows);
  cr_up = upsample(test_cr_data, nrows >> 1, ncols >> 1);
  convert_ycbcr_to_rgb(test_y_data, cb_up, cr_up, rgb, nrows, ncols);

  // write_hex_data("upsample/cb_up", cb_up, 64);
  free(cb_up);
  // write_hex_data("upsample/cr_up", cr_up, 64);
  free(cr_up);
  write_hex_data("upsample/RGB_out", rgb, 192);

  // free(test_y_data);
  // free(test_cb_data);
  // free(test_cr_data);
  free(rgb);
  return (0);
}


/*
open raw Y file
copy data
open raw Cb file
copy data
open raw Cr file
copy data
*/

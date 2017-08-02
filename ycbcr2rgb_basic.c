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
char* upsample(unsigned char* c_small, unsigned int n_small_rows, unsigned int n_small_cols) {
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
    printf("\n");

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

  printf("%d\n", small_i);
  printf("%d %d %d %d\n", big_i, big_i + 1, big_i + n_big_cols, big_i + n_big_cols + 1);

  c_big[big_i]                  = c_small[small_i];
  c_big[big_i + 1]              = c_small[small_i];
  c_big[big_i + n_big_cols]     = c_small[small_i];
  c_big[big_i + n_big_cols + 1] = c_small[small_i];

  return c_big;
}

//TODO: TEST ME
void convert_ycbcr_to_rgb(char * __restrict Y, char * __restrict Cb, char * __restrict Cr, char * __restrict RGB, unsigned int nrows, unsigned int ncols)
{
  unsigned int row = 0;
  unsigned int col;
  unsigned int i_even = 0;
  unsigned int i_odd = ncols*3 + (ncols & 3);
  unsigned int pixel = 0;
  unsigned int pixel_even = 0;

  while (1){}

}

//TODO: convert this to something useful for debugging
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

//TODO: convert this to write_bitmap_file
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

int write_hex_data(unsigned char* data, unsigned int n_bytes, char* filename) {
  // printf("Start: write_hex_data\n");
  FILE* fp = fopen(filename, "w");
  fwrite(data, n_bytes, 1, fp);
  fclose(fp);
  // printf("End: write_hex_data\n");
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

  // printf("allocate for RGB\n");
  unsigned char* rgb = (unsigned char*)malloc(3*sizeof(unsigned char)*nrows*ncols);

  //TODO: save info to header

  //unsigned int npixels = nrows * ncols;
  // printf("initialize test data\n");
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

  // printf("allocate for cb_up\n");
  char* cb_up = malloc(sizeof(char)*nrows*ncols);
  cb_up = upsample(test_cb_data, nrows >> 1, ncols >> 1);
  write_hex_data(cb_up, 64, "upsample/cb_up");
  // char* cr_up = malloc(sizeof(char)*ncols*nrows);
  // cr_up = upsample(test_cr_data, nrows >> 1, ncols >> 1);
  // write_hex_data(cb_up, 32, "upsample/cr_up");
  // convert_ycbcr_to_rgb(test_y_data, test_cb_data, test_cr_data, rgb, nrows, ncols);


  // write_raw_image_data("RGB_out.bmp", Y, npixels);

  // free(Y);
  // free(Cb);
  // free(Cr);
  // free(RGB);
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

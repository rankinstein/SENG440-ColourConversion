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
void upsample(char* c_small, unsigned int small_nrows, unsigned int small_ncols) {
  unsigned int big_nrows = small_nrows*4;
  unsigned int big_ncols = big_nrows*4;
  char* c_big = malloc(sizeof(char)*big_nrows*big_ncols);

  unsigned int row_i = 0
  unsigned int col_i = 0

  while (row_i < small_nrows-1) {

    small_col = 0
    while (col_i < small_ncols-1) {

      c_small[small_row]

      c_big[cur_index] = c_small[cur_index >> 1];
      c_big[cur_index + 1] = c_small[cur_index] + c_small[cur_index + 2] >> 2;
      c_big[cur_index + big_ncols] =

      small_col++;
    }

    small_row++
  }

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




  while ()
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

//TODO: TEST ME
char* raw_ycbcr_load(char* filename) {
  FILE* fp = fopen(filename);
  char* data;
  long file_size;
  if(!fp) {
    printf("Error opening file (%s) to read\n", filename);
  }
  fseek(fp, 0L, SEEK_END);
  file_size = ftell(fp) + 1;
  rewind(fp);
  data = (char*)malloc(file_size);
  if(data == NULL) {
    printf("Error allocating memory");
  }
  fread(data, filesize, 1, fp);
  fclose(fp);
  return data;
}

int main( int argc, char** argv) {
  printf("YCbCr to RGB: Simple Conversion\n");

  // char* y  = raw_ycbcr_load("./input/tiger.bmp");
  // char* cb = raw_ycbcr_load("")
  // char* cr = raw_ycbcr_load("")

  //Assumes height and width are positive and less than max signed int value
  unsigned int ncols  = (unsigned int)atoi(argv[1]);
  unsigned int nrows = (unsigned int)atoi(argv[2]);

  char* rgb = (char*)malloc(3*sizeof(char)*nrows*ncols);

  //TODO: save info to header

  //unsigned int npixels = nrows * ncols;

  char test_y_data[32] = {
    0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x00,0x99,
    0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x00,0x99,
    0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11,
    0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11
  };
  char test_cb_data[32] = {
    0xFF,0xDD,0xBB,0x99,0x77,0x55,0x33,0x11
  };
  char test_cr_data[32] = {
    0xFF,0xDD,0xBB,0x99,0x77,0x55,0x33,0x11
  };

  char* cb_up = malloc(sizeof(char)*nrows*ncols);
  cb_up = upsample(test_cb_data, nrows/4,ncols/4);
  char* cr_up = malloc(sizeof(char)*ncols*nrows);
  cb_up = upsample(test_cr_data, nrows/4,ncols/4);

  convert_ycbcr_to_rgb(test_y_data, test_cb_data, test_cr_data, rgb, nrows, ncols);

  write_raw_image_data("RGB_out.bmp", Y, npixels);

  free(Y);
  free(Cb);
  free(Cr);
  free(RGB);
  return (0);
}


/*
open raw Y file
copy data
open raw Cb file
copy data
open raw Cr file
copy data

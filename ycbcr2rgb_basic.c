#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
/* #include <arm_neon.h> */

#include "bmp_operations.h"

#define Y_TO_RGB (1.164)
#define CR_TO_R (1.596)
#define CR_TO_G (-0.813)
#define CB_TO_G (-0.391)
#define CB_TO_B (2.018)
#define Y_NORM_FACTOR (256)

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

float clamp_value(float f) {
  if (f < 0) {
    return 0;
  }
  if (f > 255) {
    return 255;
  }
  return f;
}

void convert_ycbcr_to_rgb(unsigned char * __restrict y, unsigned char * __restrict cb, unsigned char * __restrict cr, unsigned char * __restrict rgb, unsigned int nrows, unsigned int ncols) {
  bool must_pad = (ncols & 0x0003) != 0x0000;
  unsigned int size = nrows*ncols;
  unsigned int last_in_row = ncols;
  unsigned int rgb_i = 0;
  unsigned int ycc_i = 0;

  while (ycc_i < size) {
    while (ycc_i < last_in_row) {

      rgb[rgb_i++] = (unsigned char)clamp_value(Y_TO_RGB*((float)y[ycc_i] - 16) + CB_TO_B*((float)cb[ycc_i] - 128));
      rgb[rgb_i++] = (unsigned char)clamp_value(Y_TO_RGB*((float)y[ycc_i] - 16) + CR_TO_G*((float)cr[ycc_i] - 128) + CB_TO_G*(cb[ycc_i] - 128));
      rgb[rgb_i++] = (unsigned char)clamp_value(Y_TO_RGB*((float)y[ycc_i] - 16) + CR_TO_R*((float)cr[ycc_i] - 128));
      ycc_i++;
    }
    //add padding
    if (must_pad) {
      rgb[rgb_i++] = 0x00;
      rgb[rgb_i++] = 0x00;
    }
    last_in_row += ncols;
  }
}

bitmap_header* compose_header(unsigned int width, unsigned int height, unsigned int bitmap_size) {
  bitmap_header* header = malloc(sizeof(bitmap_header));
  strcpy(header->fileheader.filetype, "BM");
  header->fileheader.filesize = bitmap_size + 54;
  header->fileheader.reserved1 = 0;
  header->fileheader.reserved2 = 0;
  header->fileheader.dataoffset = 54;

  header->headersize = 40;
  header->width = width;
  header->height = height;
  header->planes = 1;
  header->bitsperpixel = 24;
  header->compression = 0;
  header->bitmapsize = bitmap_size;
  header->horizontalres = 2835;
  header->verticalres = 2835;
  header->numcolors = 0;
  header->importantcolors = 0;

  return header;
}

int write_bitmap(char* filename, bitmap_header* header, unsigned char* bitmap, unsigned int bitmap_size) {
  FILE* fp = fopen(filename, "wb");
  if (!fp) {
    printf("Unable to open file\n");
    return 1;
  }
  fwrite(header, sizeof(bitmap_header), 1, fp);
  fwrite(bitmap, sizeof(unsigned char), bitmap_size, fp);
  return 0;
}

int write_hex_data(char* filename, unsigned char* data, unsigned int bitmap_size) {

  FILE* fp = fopen(filename, "wb");
  if (!fp) {
    printf("Unable to open file\n");
    return 1;
  }
  fwrite(data, sizeof(unsigned char), bitmap_size, fp);
  fclose(fp);
  return 0;
}

unsigned char* make_greyscale_bitmap(unsigned char* data, unsigned int nrows, unsigned int ncols) {

  unsigned int size = nrows*ncols;
  unsigned char* greyscale_bitmap = (unsigned char*)malloc(3*sizeof(unsigned char)*nrows*ncols + 2*sizeof(unsigned char)*nrows);
  unsigned int data_i = 0,
    grey_i = 0,
    last_in_row = ncols;

  while (data_i < size) {
    while (data_i < last_in_row) {
      greyscale_bitmap[grey_i++] = data[data_i];
      greyscale_bitmap[grey_i++] = data[data_i];
      greyscale_bitmap[grey_i++] = data[data_i];
      data_i++;
    }
    greyscale_bitmap[grey_i++] = 0x00;
    greyscale_bitmap[grey_i++] = 0x00;
    last_in_row += ncols;
  }

  return greyscale_bitmap;
}

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
  if(!data) {
    printf("Error allocating memory\n");
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

  unsigned char* y  = raw_ycbcr_load("out_Y");
  unsigned char* cb = raw_ycbcr_load("out_Cb");
  unsigned char* cr = raw_ycbcr_load("out_Cr");

  //Assumes height and width are positive and less than max signed int value
  unsigned int ncols  = (unsigned int)atoi(argv[1]);
  unsigned int nrows = (unsigned int)atoi(argv[2]);

  //determine file size, accounting for padding
  bool must_pad = (ncols & 0x0003) != 0x0000;
  unsigned int bitmap_size = must_pad ?
    3*sizeof(unsigned char)*nrows*ncols + 2*sizeof(unsigned char)*nrows :
    3*sizeof(unsigned char)*nrows*ncols;

    printf("file_size: %d\n", bitmap_size);

  unsigned char* rgb = (unsigned char*)malloc(bitmap_size);
  // unsigned char test_y_data[64] = {
  //   0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x00,0x99,
  //   0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x00,0x99,
  //   0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11,
  //   0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11,
  //   0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x00,0x99,
  //   0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x00,0x99,
  //   0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11,
  //   0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11
  // };
  // unsigned char test_cb_data[16] = {
  //   0xFF,0xDD,0xBB,0x99,
  //   0x77,0x55,0x33,0x11,
  //   0xEE,0xCC,0xAA,0x88,
  //   0x66,0x44,0x22,0x00
  // };
  // unsigned char test_cr_data[16] = {
  //   0xFF,0xDD,0xBB,0x99,
  //   0x77,0x55,0x33,0x11,
  //   0xEE,0xCC,0xAA,0x88,
  //   0x66,0x44,0x22,0x00
  // };

  // unsigned char test_y_data[48] = {
  //   0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,
  //   0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,
  //   0x88,0x77,0x66,0x55,0x44,0x33,
  //   0x88,0x77,0x66,0x55,0x44,0x33,
  //   0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,
  //   0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,
  //   0x88,0x77,0x66,0x55,0x44,0x33,
  //   0x88,0x77,0x66,0x55,0x44,0x33
  // };
  // unsigned char test_cb_data[12] = {
  //   0xFF,0xDD,0xBB,
  //   0x77,0x55,0x33,
  //   0xEE,0xCC,0xAA,
  //   0x66,0x44,0x22
  // };
  // unsigned char test_cr_data[16] = {
  //   0xFF,0xDD,0xBB,
  //   0x77,0x55,0x33,
  //   0xEE,0xCC,0xAA,
  //   0x66,0x44,0x22
  // };

  unsigned char* cb_up = malloc(sizeof(unsigned char)*nrows*ncols);
  cb_up = upsample(cb, nrows >> 1, ncols >> 1);

  unsigned char* cr_up = malloc(sizeof(unsigned char)*ncols*nrows);
  cr_up = upsample(cr, nrows >> 1, ncols >> 1);

  convert_ycbcr_to_rgb(y, cb_up, cr_up, rgb, nrows, ncols);
  write_bitmap("RGB_OUT.bmp", compose_header(ncols, nrows, bitmap_size), rgb, bitmap_size);

  free(cb_up);
  free(cr_up);
  free(rgb);
  return (0);
}

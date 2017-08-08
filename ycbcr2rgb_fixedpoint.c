#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
/* #include <arm_neon.h> */

#include "bmp_operations.h"


#define Y_TO_RGB ((short int) 0x253F) // scale factor 2^-13
#define CR_TO_R  ((short int) 0x3312) // scale factor 2^-13
#define CR_TO_G  ((short int) 0xE5FC) // scale factor 2^-13
#define CB_TO_G  ((short int) 0xF37E) // scale factor 2^-13
#define CB_TO_B  ((short int) 0x4093) // scale factor 2^-13

// Converts an array of Cb or Cr values from 1:4 C values per Y to a 1:1 ratio.
// See report for details on this algorithm.
// Upsampling is done in 4 passes to avoid unnecessary branching:
//      Pass 1 - populates all values except the last 2 columns and last 2 rows
//      Pass 2 - populates last 2 rows except for the last 2 columns
//      Pass 3 - populates last 2 columns except for the last 2 rows
//      Pass 4 - populates 4 pixels in the overlap between the last 2 rows and
//               last 2 columns columns
//  Params:
//    width - pixel width of the bitmap image
//    height - pixel height of the bitmap image
//    bitmap_size - size of the bitmap in BYTES
//  Returns a populated bitmap_header
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

// Clamps the value of i between [0 - 255].  Used before casting the 32-bit int
// as an unsigned char.  Prevents rollover that dramatically changes pixel colour
//  Params:
//    i - an integer
//  Returns an int value in the range [0 - 255]
int clamp_value(int i) {
  if (i < 0) {
    return 0;
  }
  if (i > 255) {
    return 255;
  }
  return i;
}

// Creates a valid rgb bitmap from Y, Cb, Cr data.  Adds appropriate padding.
// y, cb, and cr are of equal length, with cb and cr having been upsampled before
// this function is called
//  Params:
//    y - array of y values
//    cb - array of cb values
//    cr - array of cr values
//    rgb - the output, a valid rgb bitmap with appropriate padding
//    nrows - pixel height of output bitmap
//    ncols - pixel width of output bitmap
void convert_ycbcr_to_rgb(unsigned char * __restrict y, unsigned char * __restrict cb, unsigned char * __restrict cr, unsigned char * __restrict rgb, unsigned int nrows, unsigned int ncols) {
  bool must_pad = (ncols & 0x0003) != 0x0000;
  unsigned int size = nrows*ncols;
  unsigned int last_in_row = ncols;
  unsigned int rgb_i = 0;
  unsigned int ycc_i = 0;

  while (ycc_i < size) {
    while (ycc_i < last_in_row) {

      rgb[rgb_i++] = (unsigned char)clamp_value((Y_TO_RGB*(y[ycc_i] - 16) + CB_TO_B*(cb[ycc_i] - 128)) >> 13);
      rgb[rgb_i++] = (unsigned char)clamp_value((Y_TO_RGB*(y[ycc_i] - 16) + (CR_TO_G*(cr[ycc_i] - 128) + CB_TO_G*(cb[ycc_i] - 128))) >> 13);
      rgb[rgb_i++] = (unsigned char)clamp_value((Y_TO_RGB*(y[ycc_i] - 16) + CR_TO_R*(cr[ycc_i] - 128)) >> 13);
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

// Creates a valid bitmap_header struct from known image dimensions
//  Params:
//    width - pixel width of the bitmap image
//    height - pixel height of the bitmap image
//    bitmap_size - size of the bitmap in BYTES
//  Returns a populated bitmap_header
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
  header->horizontalres = 2835; // resolution is kept constant for convenience
  header->verticalres = 2835;   // resolution is kept constant for convenience
  header->numcolors = 0;
  header->importantcolors = 0;

  return header;
}

// Writes a .bmp file using a preformatted bitmap and bitmap header.
//  Params:
//    filename - name of file to write to
//    header - a valid .bmp file header
//    bitmap - a valid bitmap containing padding
//    bitmap_size - the size of bitmap in NUMBER OF CHARS
//  Returns 0 for success, 1 for failure
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

// Used for debugging.  Turns the input array into a valid bitmap, creating three
// adjacent copies of each data point, so that it can be written to a valid
// bitmap (.bmp) file.  Used for validating the upsampling algorithm.
//  Params:
//    data - array of values in the range [0-255]
//    nrows - number of pixel rows in the bitmap
//    ncols - number of pixel columns in the bitmap
//  Returns a valid bitmap with equal R, G,and B values for each pixel, and
//        appropriate padding
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

// Loads a raw Y, Cb, or Cr file.  These files have no header information
// or padding
//  Params:
//    filename - name of file to lad
//  Returns an unsigned char array containing the file contents
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
  printf("YCbCr to RGB: conversion in fixed point\n");
  if (argc != 6) {
    printf("Not enough arguments.  Please provide, in this order, Y input file, Cb input file, Cr input file, WIDTH and HEIGHT of the image\n");
    return 0;
  }

  unsigned char* y  = raw_ycbcr_load(argv[1]);
  unsigned char* cb = raw_ycbcr_load(argv[2]);
  unsigned char* cr = raw_ycbcr_load(argv[3]);

  //Assumes height and width are positive and less than max signed int value
  unsigned int ncols  = (unsigned int)atoi(argv[4]);
  unsigned int nrows = (unsigned int)atoi(argv[5]);

  //determine file size, accounting for padding
  bool must_pad = (ncols & 0x0003) != 0x0000;
  unsigned int bitmap_size = must_pad ?
    3*sizeof(unsigned char)*nrows*ncols + 2*sizeof(unsigned char)*nrows :
    3*sizeof(unsigned char)*nrows*ncols;

  unsigned char* rgb = (unsigned char*)malloc(bitmap_size);

  // Upsample Cb and Cr values
  unsigned char* cb_up = malloc(sizeof(unsigned char)*nrows*ncols);
  cb_up = upsample(cb, nrows >> 1, ncols >> 1);
  unsigned char* cr_up = malloc(sizeof(unsigned char)*ncols*nrows);
  cr_up = upsample(cr, nrows >> 1, ncols >> 1);

  // Perform colour space conversion
  convert_ycbcr_to_rgb(y, cb_up, cr_up, rgb, nrows, ncols);

  write_bitmap("rgb_out_fixed.bmp", compose_header(ncols, nrows, bitmap_size), rgb, bitmap_size);

  free(cb_up);
  free(cr_up);
  free(rgb);
  return (0);
}

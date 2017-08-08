#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <arm_neon.h>

#include "bmp_operations.h"

#define R_TO_Y (0x440C) // scale factor 2^8
#define G_TO_Y (0x4087) // scale factor 2^7
#define B_TO_Y (0x67C7) // scale factor 2^10
#define R_TO_CB ((short int) 0xB41C) // scale factor 2^9
#define G_TO_CB ((short int) 0xB582) // scale factor 2^8
#define B_TO_CB ((short int) 0x6F70) // scale factor 2^8
#define R_TO_CR ((short int) 0x6F70) // scale factor 2^8
#define G_TO_CR ((short int) 0xA1D9) // scale factor 2^8
#define B_TO_CR ((short int) 0xB6DC) // scale factor 2^10
#define Y_NORM_FACTOR (256)
#define pixel_odd (pixel_even + ncols)

void rgb2ycbcr_fixedpoint(char * __restrict Y, char * __restrict Cb, char * __restrict Cr, char * __restrict data, unsigned int nrows, unsigned int ncols)
{
    unsigned int row = 0;
    unsigned int col;
    unsigned int i_even = 0;
    unsigned int i_odd = ncols*3 + (ncols & 3);
    unsigned int pixel = 0;
    unsigned int pixel_even = 0;
    int16x4_t r_to_y = vdup_n_s16(R_TO_Y);
    int16x4_t g_to_y = vdup_n_s16(G_TO_Y);
    int16x4_t b_to_y = vdup_n_s16(B_TO_Y);
    int16x4_t r_to_cb = vdup_n_s16(R_TO_CB);
    int16x4_t g_to_cb = vdup_n_s16(G_TO_CB);
    int16x4_t b_to_cb = vdup_n_s16(B_TO_CB);
    int16x4_t r_to_cr = vdup_n_s16(R_TO_CR);
    int16x4_t g_to_cr = vdup_n_s16(G_TO_CR);
    int16x4_t b_to_cr = vdup_n_s16(B_TO_CR);
    int32x4_t offset_y = vdupq_n_s32(0x10 << 15);
    while(row < nrows) {
      col = 0;
      while(col < ncols) {
        unsigned char R_even, G_even, B_even, R_odd, G_odd, B_odd;
        int t_Cb, t_Cr;
	uint8x8x3_t rgb_even = vld3_u8(&data[i_even]);
	uint8x8x3_t rgb_odd = vld3_u8(&data[i_odd]);
	int32x4_t temp;
        int16x4_t Y_even, Y_odd;
	int32x4_t Cb_even, Cr_even, Cb_odd, Cr_odd;
        int16x4_t red_even = vget_low_s16(vreinterpretq_s16_u16(vmovl_u8(rgb_even.val[2])));
        int16x4_t green_even = vget_low_s16(vreinterpretq_s16_u16(vmovl_u8(rgb_even.val[1])));
        int16x4_t blue_even = vget_low_s16(vreinterpretq_s16_u16(vmovl_u8(rgb_even.val[0])));
	temp = vmull_s16(blue_even, b_to_y);
        temp = vshrq_n_s32(temp, 2);
	temp = vmlal_s16(temp, red_even, r_to_y);
        temp = vshrq_n_s32(temp, 1);
        temp = vmlal_s16(temp, green_even, g_to_y);
        temp = vaddq_s32(temp, offset_y);
        Y_even = vshrn_n_s32(temp, 15);

	temp = vmull_s16(red_even, r_to_cb);
        temp = vshrq_n_s32(temp, 1);
	temp = vmlal_s16(temp, green_even, g_to_cb);
	Cb_even = vmlal_s16(temp, blue_even, b_to_cb);

	temp = vmull_s16(blue_even, b_to_cr);
	temp = vshrq_n_s32(temp, 2);
	temp = vmlal_s16(temp, green_even, g_to_cr);
	Cr_even = vmlal_s16(temp, red_even, r_to_cr);

        int16x4_t red_odd = vget_low_s16(vreinterpretq_s16_u16(vmovl_u8(rgb_odd.val[2])));
        int16x4_t green_odd = vget_low_s16(vreinterpretq_s16_u16(vmovl_u8(rgb_odd.val[1])));
        int16x4_t blue_odd = vget_low_s16(vreinterpretq_s16_u16(vmovl_u8(rgb_odd.val[0])));
	temp = vmull_s16(blue_odd, b_to_y);
        temp = vshrq_n_s32(temp, 2);
	temp = vmlal_s16(temp, red_odd, r_to_y);
        temp = vshrq_n_s32(temp, 1);
        temp = vmlal_s16(temp, green_odd, g_to_y);
        temp = vaddq_s32(temp, offset_y);
        Y_odd = vshrn_n_s32(temp, 15);

	temp = vmull_s16(red_odd, r_to_cb);
        temp = vshrq_n_s32(temp, 1);
	temp = vmlal_s16(temp, green_odd, g_to_cb);
	Cb_odd = vmlal_s16(temp, blue_odd, b_to_cb);

	temp = vmull_s16(blue_odd, b_to_cr);
	temp = vshrq_n_s32(temp, 2);
	temp = vmlal_s16(temp, green_odd, g_to_cr);
	Cr_odd = vmlal_s16(temp, red_odd, r_to_cr);
	
        int64x2_t temp_64x2;
        int32x2_t temp_32x2;
	temp_64x2 = vpaddlq_s32(Cb_even);
        temp_64x2 = vpadalq_s32(temp_64x2, Cb_odd);
	temp_32x2 = vqrshrn_n_s64(temp_64x2, 18) + 128;

	int temp_Cb[2];
	vst1_s32(temp_Cb, temp_32x2); 

	temp_64x2 = vpaddlq_s32(Cr_even);
        temp_64x2 = vpadalq_s32(temp_64x2, Cr_odd);
	temp_32x2 = vqrshrn_n_s64(temp_64x2, 18) + 128;

	int temp_Cr[2];
	vst1_s32(temp_Cr, temp_32x2);

	int temp_Y_even[4];
	int temp_Y_odd[4];
	vst1_s16(temp_Y_even, Y_even);
   	vst1_s16(temp_Y_odd, Y_odd);
	
	// TODO Store vector data into data array

        Y[pixel_even] = (char) (temp_Y_even[0]);
        Y[pixel_odd] = (char) (temp_Y_odd[0]);
        pixel_even++;
        col++;

        Cb[pixel] = (char) (temp_Cb[0]);
        Cr[pixel] = (char) (temp_Cr[0]);
	
	pixel++;

        Cb[pixel] = (char) (temp_Cb[1]);
        Cr[pixel] = (char) (temp_Cr[1]);

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

  char* Y = (char*) malloc(npixels);
  char* Cb = (char*) malloc(npixels/4);
  char* Cr = (char*) malloc(npixels/4);

  rgb2ycbcr_fixedpoint(Y, Cb, Cr, image->data, nrows, ncols);

  // print_triple_char(Y, npixels, Cb, npixels/4, Cr, npixels/4);

  write_raw_image_data("out_Y", Y, npixels);
  write_raw_image_data("out_Cb", Cb, npixels/4);
  write_raw_image_data("out_Cr", Cr, npixels/4);

  free(Y);
  free(Cb);
  free(Cr);
  return (0);
}

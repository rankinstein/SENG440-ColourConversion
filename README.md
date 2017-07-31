# Progress
2017-07-24
nearly have the basic conversion with floats complete.  I think it is safe to make the assumption that resolutions are always divisible by 2.  We may also want to constrain the problem by assuming that data values are not padded at the end of lines, this is somewhat reasonable as nearly every standard video resolution is a multiple of 4 (exceptions are 1650x1080ish and 426x240ish).

The code can be vectorized with:
arm-none-eabi-gcc -S -O3 -mfpu=neon -mfloat-abi=softfp -ftree-vectorize -ftree-vectorizer-verbose=2 -c basic_conversion.c

Need to come up with benchmark/test image data structures then we could compare performance on a raspberry pi to have some idea of efficiency.


# Todo
1. Benchmark data
2. Conversion to fixed point arithmetic


# Image Conversion
Imagemagick is very promising
To break an image into Luminance and Chroma channels use:
`convert ./input/tiger.bmp -colorspace YUV -sampling-factor 4:2:2 -separate tiger_yuv_append.png`

And to combine three channels back into an RGB color image use:
`convert ./tiger_yuv_append-0.png ./tiger_yuv_append-1.png ./tiger_yuv_append-2.png -colorspace YCbCr -combine recomp.png`

## Image scaling
when we save a downsampled image it is going to be 1/2 the resolution in each direction. If we want to check out the quality when recombined it is necessary to scale it so that it can be recomposed. This re-scaling can be done in ImageMagick:
`convert -size 8x8 pattern:gray50  checks_sm.gif` // just creating an example image. An 8x8 checker pattern
`convert checks_sm.gif -sample 16x16 checks_2x.gif` // double the image size using pixel replication

# Progress
2017-07-24
nearly have the basic conversion with floats complete.  I think it is safe to make the assumption that resolutions are always divisible by 2.  We may also want to constrain the problem by assuming that data values are not padded at the end of lines, this is somewhat reasonable as nearly every standard video resolution is a multiple of 4 (exceptions are 1650x1080ish and 426x240ish).

The code can be vectorized with:
arm-none-eabi-gcc -S -O3 -mfpu=neon -mfloat-abi=softfp -ftree-vectorize -ftree-vectorizer-verbose=2 -c basic_conversion.c

Need to come up with benchmark/test image data structures then we could compare performance on a raspberry pi to have some idea of efficiency.


# Todo
1. Benchmark data
2. Conversion to fixed point arithmetic

# Makefile
# Boilerplate from: http://www.icosaedro.it/c-modules.html

SHELL = /bin/bash

# Compiler
CC = gcc

# Compiler flags: all warnings + debugger meta-data
CFLAGS = -Wall -g

# External libraries: only math in this example
LIBS = -lm

# Pre-defined macros for conditional compilation
DEFS = -DDEBUG_FLAG -DEXPERIMENTAL=0

# The final executable program file, i.e. name of our program
BIN = rgb2ycbcr_fixedpoint

# Object files from which $BIN depends
OBJS = bmp_operations.o

# This default rule compiles the executable program
$(BIN): $(OBJS) $(BIN).c
	$(CC) $(CFLAGS) $(DEFS) $(LIBS) $(OBJS) $(BIN).c -o $(BIN)

# This rule compiles each module into its object file
%.o: %.c %.h
	$(CC) -c $(CFLAGS) $(DEFS) $< -o $@

clean:
	rm -f *~ *.o $(BIN)

depend:
	makedepend -Y -- $(CFLAGS) $(DEFS) -- *.c

# Run this rule to convert the raw output into a bitmap and recompose it back into a single image
# example:  make raw2bmp width=630 height=354
raw2bmp:
	convert -depth 8 -size $(width)x$(height) +flip gray:out_Y out_Y.bmp
	convert -depth 8 -size $$(( $(width)/2 ))x$$(( $(height)/2 )) -sample $(width)x$(height) +flip gray:out_Cb out_Cb.bmp
	convert -depth 8 -size $$(( $(width)/2 ))x$$(( $(height)/2 )) -sample $(width)x$(height) +flip gray:out_Cr out_Cr.bmp
	convert out_Y.bmp out_Cb.bmp out_Cr.bmp -colorspace YCbCr -combine out_recomposed.bmp

bins:
	$(CC) ./rgb2ycbcr_basic.c bmp_operations.c -o ./bin/rgb2ycbcr_basic -lm
	$(CC) ./rgb2ycbcr_basic.c bmp_operations.c -o ./bin/rgb2ycbcr_vec_basic -lm -ftree-vectorize
	$(CC) -O1 ./rgb2ycbcr_basic.c bmp_operations.c -o ./bin/rgb2ycbcr_basic_O1 -lm
	$(CC) -O1 ./rgb2ycbcr_basic.c bmp_operations.c -o ./bin/rgb2ycbcr_vec_basic_O1 -lm -ftree-vectorize
	$(CC) -O2 ./rgb2ycbcr_basic.c bmp_operations.c -o ./bin/rgb2ycbcr_basic_O2 -lm
	$(CC) -O2 ./rgb2ycbcr_basic.c bmp_operations.c -o ./bin/rgb2ycbcr_vec_basic_O2 -lm -ftree-vectorize
	$(CC) -O3 ./rgb2ycbcr_basic.c bmp_operations.c -o ./bin/rgb2ycbcr_basic_O3 -lm
	$(CC) -O3 ./rgb2ycbcr_basic.c bmp_operations.c -o ./bin/rgb2ycbcr_vec_basic_O3 -lm -ftree-vectorize

	$(CC) ./rgb2ycbcr_fixedpoint.c bmp_operations.c -o ./bin/rgb2ycbcr_fixed
	$(CC) ./rgb2ycbcr_fixedpoint.c bmp_operations.c -o ./bin/rgb2ycbcr_vec_fixed -ftree-vectorize
	$(CC) -O1 ./rgb2ycbcr_fixedpoint.c bmp_operations.c -o ./bin/rgb2ycbcr_fixed_O1
	$(CC) -O1 ./rgb2ycbcr_fixedpoint.c bmp_operations.c -o ./bin/rgb2ycbcr_vec_fixed_O1 -ftree-vectorize
	$(CC) -O2 ./rgb2ycbcr_fixedpoint.c bmp_operations.c -o ./bin/rgb2ycbcr_fixed_O2
	$(CC) -O2 ./rgb2ycbcr_fixedpoint.c bmp_operations.c -o ./bin/rgb2ycbcr_vec_fixed_O2 -ftree-vectorize
	$(CC) -O3 ./rgb2ycbcr_fixedpoint.c bmp_operations.c -o ./bin/rgb2ycbcr_fixed_O3
	$(CC) -O3 ./rgb2ycbcr_fixedpoint.c bmp_operations.c -o ./bin/rgb2ycbcr_vec_fixed_O3 -ftree-vectorize

perf:
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/tiger_basic.txt ./bin/rgb2ycbcr_basic ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/tiger_basic_O1.txt ./bin/rgb2ycbcr_basic_O1 ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/tiger_basic_O2.txt ./bin/rgb2ycbcr_basic_O2 ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/tiger_basic_O3.txt ./bin/rgb2ycbcr_basic_O3 ./input/tiger.bmp

	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/marbles_basic.txt ./bin/rgb2ycbcr_basic ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/marbles_basic_O1.txt ./bin/rgb2ycbcr_basic_O1 ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/marbles_basic_O2.txt ./bin/rgb2ycbcr_basic_O2 ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/marbles_basic_O3.txt ./bin/rgb2ycbcr_basic_O3 ./input/marbles.bmp

	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/tiger_fixed.txt ./bin/rgb2ycbcr_fixed ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/tiger_fixed_O1.txt ./bin/rgb2ycbcr_fixed_O1 ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/tiger_fixed_O2.txt ./bin/rgb2ycbcr_fixed_O2 ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/tiger_fixed_O3.txt ./bin/rgb2ycbcr_fixed_O3 ./input/tiger.bmp

	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/marbles_fixed.txt ./bin/rgb2ycbcr_fixed ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/marbles_fixed_O1.txt ./bin/rgb2ycbcr_fixed_O1 ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/marbles_fixed_O2.txt ./bin/rgb2ycbcr_fixed_O2 ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/marbles_fixed_O3.txt ./bin/rgb2ycbcr_fixed_O3 ./input/marbles.bmp

	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_tiger_basic.txt ./bin/rgb2ycbcr_vec_basic ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_tiger_basic_O1.txt ./bin/rgb2ycbcr_vec_basic_O1 ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_tiger_basic_O2.txt ./bin/rgb2ycbcr_vec_basic_O2 ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_tiger_basic_O3.txt ./bin/rgb2ycbcr_vec_basic_O3 ./input/tiger.bmp

	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_marbles_basic.txt ./bin/rgb2ycbcr_vec_basic ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_marbles_basic_O1.txt ./bin/rgb2ycbcr_vec_basic_O1 ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_marbles_basic_O2.txt ./bin/rgb2ycbcr_vec_basic_O2 ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_marbles_basic_O3.txt ./bin/rgb2ycbcr_vec_basic_O3 ./input/marbles.bmp

	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_tiger_fixed.txt ./bin/rgb2ycbcr_vec_fixed ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_tiger_fixed_O1.txt ./bin/rgb2ycbcr_vec_fixed_O1 ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_tiger_fixed_O2.txt ./bin/rgb2ycbcr_vec_fixed_O2 ./input/tiger.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_tiger_fixed_O3.txt ./bin/rgb2ycbcr_vec_fixed_O3 ./input/tiger.bmp

	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_marbles_fixed.txt ./bin/rgb2ycbcr_vec_fixed ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_marbles_fixed_O1.txt ./bin/rgb2ycbcr_vec_fixed_O1 ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_marbles_fixed_O2.txt ./bin/rgb2ycbcr_vec_fixed_O2 ./input/marbles.bmp
	perf_3.16 stat --repeat 100 -e cpu-cycles,instructions,branches,branch-misses,cpu-clock,page-faults,context-switches,cache-references,cache-misses -o results/vec_marbles_fixed_O3.txt ./bin/rgb2ycbcr_vec_fixed_O3 ./input/marbles.bmp

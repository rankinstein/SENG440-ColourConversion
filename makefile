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
BIN = rgb2ycbcr_basic

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

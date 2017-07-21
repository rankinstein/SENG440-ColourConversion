#include <stdlib.h>
#include <stdio.h>
// https://stackoverflow.com/questions/11129138/reading-writing-bmp-files-in-c

#pragma pack(push,1)
/* Windows 3.x bitmap file header */
typedef struct file_header {
    char         filetype[2];   /* magic - always 'B' 'M' */
    unsigned int filesize;
    short        reserved1;
    short        reserved2;
    unsigned int dataoffset;    /* offset in bytes to actual bitmap data */
} file_header;

/* Windows 3.x bitmap full header, including file header */
typedef struct bitmap_header {
    file_header  fileheader;
    unsigned int headersize;
    int          width;
    int          height;
    short        planes;
    short        bitsperpixel;  /* we only support the value 24 here */
    unsigned int compression;   /* we do not support compression */
    unsigned int bitmapsize;
    int          horizontalres;
    int          verticalres;
    unsigned int numcolors;
    unsigned int importantcolors;
} bitmap_header;
#pragma pack(pop)

int print_header(char* input) {

    //variable dec:
    FILE *fp;
    bitmap_header* hp;

    //Open input file:
    fp = fopen(input, "rb");

    //Read the input file headers:
    hp=(bitmap_header*)malloc(sizeof(bitmap_header));

    fread(hp, sizeof(bitmap_header), 1, fp);

    //print file information
    printf("filesize: %d\ndataoffset: %d\nheadersize: %d\nwidth: %d\nheight: %d\nplanes: %d\nbitsperpixel: %d\nbitmap size: %d\nhorizontal resolution: %d\nvertical resolution: %d\nnumcolors: %d\nimportantcolors: %d\n", hp->fileheader.filesize, hp->fileheader.dataoffset, hp->headersize, hp->width, hp->height, hp->planes,hp->bitsperpixel, hp->bitmapsize, hp->horizontalres, hp->verticalres, hp->numcolors, hp->importantcolors);

    fclose(fp);
    free(hp);

    return 0;
}

int main(int argc, char **argv) {
    if(argc == 2) print_header(argv[1]);
    else printf("[ERROR] no file specified");
}

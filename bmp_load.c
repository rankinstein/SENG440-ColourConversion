#include <stdlib.h>
#include <stdio.h>
// https://stackoverflow.com/questions/11129138/reading-writing-bmp-files-in-c

#pragma pack(push,1)
/* Windows 3.x bitmap file header */
typedef struct {
    char         filetype[2];   /* magic - always 'B' 'M' */
    unsigned int filesize;
    short        reserved1;
    short        reserved2;
    unsigned int dataoffset;    /* offset in bytes to actual bitmap data */
} file_header;

/* Windows 3.x bitmap full header, including file header */
typedef struct {
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

int foo(char* input, char *output) {

    //variable dec:
    FILE *fp,*out;
    bitmap_header* hp;
    int n;
    char *data;

    //Open input file:
    fp = fopen(input, "rb");
    if(fp==NULL){
        //cleanup
    }


    //Read the input file headers:
    hp=(bitmap_header*)malloc(sizeof(bitmap_header));
    if(hp==NULL)
        return 3;

    n=fread(hp, sizeof(bitmap_header), 1, fp);
    if(n<1){
        //cleanup
    }

    //print file information
    printf("filesize: %d\ndataoffset: %d\nheadersize: %d\nwidth: %d\nheight: %d\nbitsperpixel: %d\nbitmap size: %d\nhorizontal resolution: %d\nvertical resolution: %d\nnumcolors: %d\nimportantcolors: %d\n", hp->fileheader.filesize, hp->fileheader.dataoffset, hp->headersize, hp->width, hp->height, hp->bitsperpixel, hp->bitmapsize, hp->horizontalres, hp->verticalres, hp->numcolors, hp->importantcolors);

    //correct for abesnt bitmapsize
    if(hp->bitmapsize == 0){
        hp->bitmapsize = hp->fileheader.filesize - 54;
    }

    //Read the data of the image:
    data = (char*)malloc(sizeof(char)*hp->bitmapsize);
    if(data==NULL){
        //cleanup
    }

    fseek(fp,sizeof(char)*hp->fileheader.dataoffset,SEEK_SET);
    n=fread(data,sizeof(char),hp->bitmapsize, fp);
    if(n<1){
        //cleanup
    }

        //Open output file:
    out = fopen(output, "wb");
    if(out==NULL){
        //cleanup
    }

    n=fwrite(hp,sizeof(char),sizeof(bitmap_header),out);
    if(n<1){
        //cleanup
    }
    fseek(out,sizeof(char)*hp->fileheader.dataoffset,SEEK_SET);
    n=fwrite(data,sizeof(char),hp->bitmapsize,out);
    if(n<1){
        //cleanup
    }

    fclose(fp);
    fclose(out);
    free(hp);
    free(data);
    return 0;
}

int main(void) {
  printf("Init\n");
  foo("./input/baboon.bmp", "./output/baboon.bmp");
}

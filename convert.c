#include <stdlib.h>
#include <stdio.h>
#include <string.h>
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

file_header* create_8_bit_file_header(file_header fh) {
    file_header* new_fh;
    new_fh = (file_header*)malloc(sizeof(file_header));

    strcpy(new_fh->filetype, fh.filetype);
    new_fh->filesize    = (fh.filesize - 54)/3 + 54;
    new_fh->reserved1   = fh.reserved1;
    new_fh->reserved2   = fh.reserved2;
    new_fh->dataoffset  = fh.dataoffset;

    return new_fh;
}

bitmap_header* create_8_bit_bitmap_header(bitmap_header bmh) {

    bitmap_header* new_bmh;
    new_bmh = (bitmap_header*)malloc(sizeof(bitmap_header));

    new_bmh->fileheader     = *create_8_bit_file_header(bmh.fileheader);
    new_bmh->headersize     = bmh.headersize;
    new_bmh->width          = bmh.width;
    new_bmh->height         = bmh.height;
    new_bmh->planes         = bmh.planes;
    new_bmh->bitsperpixel   = 8;
    new_bmh->compression    = bmh.compression;
    new_bmh->bitmapsize     = bmh.bitmapsize/3;
    new_bmh->horizontalres  = bmh.horizontalres;
    new_bmh->verticalres    = bmh.verticalres;
    new_bmh->numcolors      = bmh.numcolors;
    new_bmh->importantcolors= bmh.importantcolors;

    return new_bmh;
}

int convert(char* input, char* output) {

    //variable dec:
    FILE *fp,*out;
    bitmap_header* hp;
    char *data;

    //Open input file:
    fp = fopen(input, "rb");
    if(fp==NULL){
        //cleanup
    }


    //Read the input file headers:
    hp=(bitmap_header*)malloc(sizeof(bitmap_header));

    fread(hp, sizeof(bitmap_header), 1, fp);

    //print file information
    printf("filesize: %d\ndataoffset: %d\nheadersize: %d\nwidth: %d\nheight: %d\nplanes: %d\nbitsperpixel: %d\nbitmap size: %d\nhorizontal resolution: %d\nvertical resolution: %d\nnumcolors: %d\nimportantcolors: %d\n", hp->fileheader.filesize, hp->fileheader.dataoffset, hp->headersize, hp->width, hp->height, hp->planes,hp->bitsperpixel, hp->bitmapsize, hp->horizontalres, hp->verticalres, hp->numcolors, hp->importantcolors);

    //correct for abesnt bitmapsize
    if(hp->bitmapsize == 0){
        hp->bitmapsize = hp->fileheader.filesize - 54;
    }

    //Read the data of the image:
    data = (char*)malloc(sizeof(char)*(hp->width*hp->height + hp->width*hp->height/2));
    if(data==NULL){
        printf("[ERROR] data allocated to output is NULL");
    }

    //set file file pointer to start bitmap
    fseek(fp,sizeof(char)*hp->fileheader.dataoffset,SEEK_SET);
    fread(data,sizeof(char),hp->bitmapsize, fp);

    //Open output files
    printf("\nopening output files\n");
    out = fopen(output, "wb");

    if (!out) perror("fopen");

    // fwrite("bullshit", sizeof(char), 8, out);
    //
    // //Iterate over input file, split into 3 components
    // //FIXME: look up whether to use an unsigned int for the for loop
    // printf("writing to file\n");
    // unsigned int i;
    //
    // //Convert Y value
    // for(i = 0; i < 1; i++){ // hp->bitmapsize-1   i=i+3
    //     char r = *(data + i);
    //     char g = *(data + i + 1);
    //     char b = *(data + i + 2);
    //
    //     unsigned int y = (unsigned int)r;
    //     unsigned int u = (unsigned int)g;
    //     unsigned int v = (unsigned int)b;
    //
    //     printf("%d %d %d\n", y, u ,v);
    // }

    fclose(fp);
    fclose(out);
    free(hp);
    free(data);
    return 0;
}

int main(void) {
  printf("Init\n");
  convert("./input/FLAG_B24_sm.bmp", "./test/out.yuc");
}

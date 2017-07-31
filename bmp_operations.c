#include "bmp_operations.h"

bitmap_image* bmp_load(char* filename) {
  FILE *fp;
  bitmap_image* bp;
  int n;

  fp = fopen(filename, "rb");
  if(fp==NULL) {
    printf("Error opening bitmap: %s\n", filename);
  }

  bp = (bitmap_image*) malloc(sizeof(bitmap_image));
  if(bp==NULL){
    printf("Error allocating bitmap header\n");
    fclose(fp);
  }

  n=fread(&(bp->header), sizeof(bitmap_header), 1, fp);
  if(n<1){
    printf("Error reading file header\n");
    fclose(fp);
    free(bp);
  }

  // Correct for default if size is absent
  if(bp->header.bitmapsize == 0) {
    bp->header.bitmapsize = bp->header.fileheader.filesize-54;
  }

  bp->data = (char*)malloc(sizeof(char)*bp->header.bitmapsize);
  if(bp->data==NULL){
    printf("Error allocating file data memory\n");
    fclose(fp);
    free(bp);
  }

  fseek(fp, sizeof(char)*bp->header.fileheader.dataoffset, SEEK_SET);
  n=fread(bp->data, sizeof(char), bp->header.bitmapsize, fp);
  if(n<1){
    printf("Error heading file data\n");
    fclose(fp);
    free(bp->data);
    free(bp);
  }

  return bp;
}

void bmp_free(bitmap_image* image) {
  free(image->data);
  free(image);
}

void hello(){
  printf("Hello\n");
}

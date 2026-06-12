#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define NUM_TESTS 100

static const int8_t twd_re[8] = {
    0x7F, //w0=1
    0x5B, //w1=1/sqrt2
    0x00, //w2=0
    0xA5, //w3=-1/sqrt2
    0x80, //w4=-1
    0xA5, //w5=-1/sqrt2
    0x00, //w6=0
    0x5B  //W7=1/sqrt2
};

static const int8_t twd_im[8] = {
    0x00, //w0=0
    0xA5, //w1=-1/sqrt2
    0x80, //w2=-1
    0xA5, //w3=-1/sqrt2
    0x00, //w4=0
    0x5B, //w5=1/sqrt2
    0x7F, //w6=1
    0x5B  //W7=1/sqrt2
};
int main(void){
    srand(10);

    int8_t re_a[NUM_TESTS];
    int8_t re_b[NUM_TESTS];
    
    int8_t re_y[NUM_TESTS];
    int8_t im_y[NUM_TESTS];
    int8_t re_z[NUM_TESTS];
    int8_t im_z[NUM_TESTS];

    // generating random 8-bit integer testvector of A and B
    for (int i=0; i<NUM_TESTS; i++) {
        re_a[i]= (rand() % 256) - 128;
        re_b[i]= (rand() % 256) - 128;
    }

    // calculating reference results
    for (int i=0; i<NUM_TESTS; i++) {
        int8_t re_w= twd_re[i % 8]; // looping around index 7
        int8_t im_w= twd_im[i % 8]; // looping around index 7

        int16_t multRes_16b = (int16_t) re_b[i] * (int16_t) re_w; 
        int16_t im_y_16b = (int16_t) re_b[i] * (int16_t) im_w;
        
        int8_t multRes = (int8_t) ( multRes_16b >>7) ;
        int8_t im_y_temp = (int8_t) ( im_y_16b >>7) ;

        re_y[i]= (int8_t)(re_a[i] + multRes);
        re_z[i]= (int8_t)(re_a[i] - multRes);
        im_y[i]= im_y_temp;
        im_z[i]= (int8_t)( 0 - im_y[i]);
    }

    //printing SystemVerilog style test vectors
    printf("logic signed [7:0] test_a [0:%d] = '{", NUM_TESTS-1);
    for (int i=0; i<NUM_TESTS; i++) {
        printf("8'h%02X", (uint8_t)re_a[i]);
        if(i<NUM_TESTS-1) printf(", ");
    }
    printf("};\n");

    printf("logic signed [7:0] test_b [0:%d] = '{", NUM_TESTS-1);
    for (int i=0; i<NUM_TESTS; i++) {
        printf("8'h%02X", (uint8_t)re_b[i]);
        if(i<NUM_TESTS-1) printf(", ");
    }
    printf("};\n");


    printf("logic signed [7:0] test_w [0:%d] = '{", NUM_TESTS-1);
    for (int i=0; i<NUM_TESTS; i++) {
        printf("8'h%02X", i % 8);
        if(i<NUM_TESTS-1) printf(", ");
    }
    printf("};\n\n");

    printf("logic signed [7:0] exp_rey [0:%d] = '{", NUM_TESTS-1);
    for (int i=0; i<NUM_TESTS; i++) {
        printf("8'h%02X", (uint8_t)re_y[i]);
        if(i<NUM_TESTS-1) printf(", ");
    }
    printf("};\n");

    printf("logic signed [7:0] exp_imy [0:%d] = '{", NUM_TESTS-1);
    for (int i=0; i<NUM_TESTS; i++) {
        printf("8'h%02X", (uint8_t)im_y[i]);
        if(i<NUM_TESTS-1) printf(", ");
    }
    printf("};\n");
    
    printf("logic signed [7:0] exp_rez [0:%d] = '{", NUM_TESTS-1);
    for (int i=0; i<NUM_TESTS; i++) {
        printf("8'h%02X", (uint8_t)re_z[i]);
        if(i<NUM_TESTS-1) printf(", ");
    }
    printf("};\n");

    printf("logic signed [7:0] exp_imz [0:%d] = '{", NUM_TESTS-1);
    for (int i=0; i<NUM_TESTS; i++) {
        printf("8'h%02X", (uint8_t)im_z[i]);
        if(i<NUM_TESTS-1) printf(", ");
    }
    printf("};\n");

    printf("\n//Reference vectors:\n");
    printf("// W  ,  Re_a,  Re_a,  Re_y,  Im_y,  Re_z,  Im_z\n");
    for (int i=0; i<4; i++) { //printing 3 reference values
        printf("// %02X  ,  %02X,    %02X,    %02X,    %02X,    %02X,    %02X\n",
            i%8 , (uint8_t)re_a[i] , (uint8_t)re_b[i], (uint8_t)re_y[i], (uint8_t)im_y[i], (uint8_t)re_z[i], (uint8_t)im_z[i]);
    }
    return 0;
};
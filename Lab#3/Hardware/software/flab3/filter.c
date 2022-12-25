#include<stdio.h>

const double coef[64]={
-0.0019989013671875,                                         
-0.0050506591796875,                                         
-0.008331298828125 ,                                         
-0.0105438232421875,                                         
-0.0092926025390625,                                         
-0.0046539306640625,                                         
 0.0021209716796875,                                         
 0.0072174072265625,                                         
 0.0078125         ,                                         
 0.0027618408203125,                                         
-0.004852294921875 ,                                         
-0.0102081298828125,                                         
-0.008819580078125 ,                                         
-0.0006866455078125,                                         
 0.0095977783203125,                                         
 0.0146331787109375,                                         
 0.009735107421875 ,                                         
-0.0036163330078125,                                         
-0.0170440673828125,                                         
-0.0205535888671875,                                         
-0.009063720703125 ,                                         
 0.01220703125     ,                                         
 0.0296478271484375,                                         
 0.028717041015625 ,                                         
 0.00469970703125  ,                                         
-0.031494140625    ,                                         
-0.056121826171875 ,                                         
-0.0446319580078125,                                         
 0.013763427734375 ,                                         
 0.106964111328125 ,                                         
 0.2028656005859375,                                         
 0.2635040283203125,                                         
 0.2635040283203125,                                         
 0.2028656005859375,                                         
 0.106964111328125 ,                                         
 0.013763427734375 ,                                         
-0.0446319580078125,                                         
-0.056121826171875 ,                                         
-0.031494140625    ,                                         
 0.00469970703125  ,                                         
 0.028717041015625 ,                                         
 0.0296478271484375,                                         
 0.01220703125     ,                                         
-0.009063720703125 ,                                         
-0.0205535888671875,                                         
-0.0170440673828125,                                         
-0.0036163330078125,                                         
 0.009735107421875 ,                                         
 0.0146331787109375,                                         
 0.0095977783203125,                                         
-0.0006866455078125,                                         
-0.008819580078125 ,                                         
-0.0102081298828125,                                         
-0.004852294921875 ,                                         
 0.0027618408203125,                                         
 0.0078125         ,                                         
 0.0072174072265625,                                         
 0.0021209716796875,                                         
-0.0046539306640625,                                         
-0.0092926025390625,                                         
-0.0105438232421875,                                         
-0.008331298828125 ,                                         
-0.0050506591796875,
-0.0019989013671875                                             
};

extern double mem[64];

double filter(double in){
    int i;
    for (i=63;i>0;i--){
        mem[i]=mem[i-1];
    }
    mem[0]=in;
    double res=0;
    for(i=0;i<64;i++){
        res+=mem[i]*coef[i];
    }
    return res;
}
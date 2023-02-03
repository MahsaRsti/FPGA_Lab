#include "globals.h"

/* global variables */
volatile int buf_index_record, buf_index_play;		// audio variables

volatile unsigned char byte1, byte2, byte3;			// PS/2 variables
unsigned char valid_byte1, valid_byte2, valid_byte3;
volatile unsigned char cnt, flag_mouse, flag_denoise, command;	
unsigned int l_buf_Denoise[BUF_SIZE];				// audio echo buffer
unsigned int r_buf_Denoise[BUF_SIZE];				// audio echo buffer
int means[N] = {0};
int heights[N] = {0};
short new_record_flag = 1, flag_play = 0, flag_is_playing = 0;

float mem[64] = {0};	

volatile int timeout;										// used to synchronize with the timer

struct alt_up_dev up_dev;									/* struct to hold pointers to open devices */

volatile int* amp_cal = AMPP_0_BASE;
volatile int* config_reg = AMPP_0_BASE;
volatile int* right_addr = AMPP_0_BASE + 4;
volatile int* left_addr = AMPP_0_BASE + 8;
volatile int* out_addr = AMPP_0_BASE + 12;



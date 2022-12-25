#include "globals.h"

/* global variables */
volatile int buf_index_record, buf_index_play;		// audio variables

volatile unsigned char byte1, byte2, byte3;			// PS/2 variables
unsigned char valid_byte1, valid_byte2, valid_byte3;
volatile unsigned char cnt, flag_mouse, flag_denoise, command;	
unsigned int l_buf_Denoise[BUF_SIZE];				// audio echo buffer
unsigned int r_buf_Denoise[BUF_SIZE];				// audio echo buffer

float mem[64] = {0};	

volatile int timeout;										// used to synchronize with the timer

struct alt_up_dev up_dev;									/* struct to hold pointers to open devices */

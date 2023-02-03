#include "globals.h"


extern volatile int* amp_cal;
extern volatile int* config_reg;
extern volatile int* right_addr;
extern volatile int* left_addr;
extern volatile int* out_addr;
/* globals used for audio record/playback */
extern volatile int buf_index_record, buf_index_play;
extern volatile unsigned char command;
unsigned int l_buf[BUF_SIZE];					// audio buffer
unsigned int r_buf[BUF_SIZE];					// audio buffer
extern unsigned int l_buf_Denoise[BUF_SIZE];				// audio echo buffer
extern unsigned int r_buf_Denoise[BUF_SIZE];				// audio echo buffer
extern volatile unsigned char flag_denoise;
extern int means[N];
extern int heights[N];
extern short new_record_flag, flag_play, flag_is_playing;
void take_mean();
int eq = 0;
/***************************************************************************************
 * Audio - Interrupt Service Routine                                
 *                                                                          
 * This interrupt service routine records or plays back audio, depending on which type
 * interrupt (read or write) is pending in the audio device.
****************************************************************************************/
void audio_ISR(struct alt_up_dev *up_dev, unsigned int id)
{
	int num_read; int num_written;

	unsigned int fifospace;
		
	if (alt_up_audio_read_interrupt_pending(up_dev->audio_dev))	// check for read interrupt
	{
		alt_up_parallel_port_write_data (up_dev->green_LEDs_dev, 0x1); // set LEDG[0] on

		// store data until the buffer is full
		if (buf_index_record < BUF_SIZE)
		{
			num_read = alt_up_audio_record_r (up_dev->audio_dev, &(r_buf[buf_index_record]), 
				BUF_SIZE - buf_index_record);
			/* assume we can read same # words from the left and right */
			(void) alt_up_audio_record_l (up_dev->audio_dev, &(l_buf[buf_index_record]), 
				num_read);
			buf_index_record += num_read;

			if (buf_index_record == BUF_SIZE)
			{
				// done recording
				alt_up_parallel_port_write_data (up_dev->green_LEDs_dev, 0); // turn off LEDG
				alt_up_audio_disable_read_interrupt(up_dev->audio_dev);
				take_mean();
				new_record_flag = 1;
			}
		}
	}
	if (alt_up_audio_write_interrupt_pending(up_dev->audio_dev))	// check for write interrupt
	{
		alt_up_parallel_port_write_data (up_dev->green_LEDs_dev, 0x2); // set LEDG[1] on

		
		// output data until the buffer is empty 
		if (buf_index_play < BUF_SIZE)
		{
			flag_is_playing = 1;
			if(!flag_denoise){
				num_written = alt_up_audio_play_r (up_dev->audio_dev, &(r_buf[buf_index_play]), 
					BUF_SIZE - buf_index_play);
				/* assume that we can write the same # words to the left and right */
				(void) alt_up_audio_play_l (up_dev->audio_dev, &(l_buf[buf_index_play]), 
					num_written);
				buf_index_play += num_written;
			}
			else if(flag_denoise){
				num_written = alt_up_audio_play_r (up_dev->audio_dev, &(r_buf_Denoise[buf_index_play]), 
					BUF_SIZE - buf_index_play);
				/* assume that we can write the same # words to the left and right */
				(void) alt_up_audio_play_l (up_dev->audio_dev, &(l_buf_Denoise[buf_index_play]), 
					num_written);
				buf_index_play += num_written;
			}
			if(buf_index_play>=eq){
				flag_play = 1;
				eq += BUF_SIZE / N;
			}
			if (buf_index_play == BUF_SIZE)
			{
				// done playback
				eq = 0;
				flag_is_playing = 0;
				alt_up_parallel_port_write_data (up_dev->green_LEDs_dev, 0); // turn off LEDG
				alt_up_audio_disable_write_interrupt(up_dev->audio_dev);
			}
		}
	}
	return;
}

////////////////////////////////////////////////////////////////////////////////////
//hardware

void take_mean() {
	int i, j;
	int num = BUF_SIZE / N;
	alt_64 sum = 0;
	*config_reg = (int)(N << 1); // Num set
	*config_reg |= (int)(num << 12); //Size set
	*right_addr = r_buf;
	*left_addr = l_buf;
	*out_addr = 0x60000000;
	*config_reg |= 0x01; // go = 1
	while(!((*config_reg >> 31) & 0x01)); //Done = 1
	for (j = 0; j < N; j++) {
		sum = 0;
		sum = (alt_64)(*out_addr) + (alt_64)(*(out_addr + 4)) << 32;
		means[j] = (int) (sum / num);
	}
	int max = 0;
	int min = means[0];
	for (i = 0; i < N; i++) {
		if (max < means[i]) {
			max = means[i];
		}
		if (min>means[i]){
			min = means[i];
		}
	}
	int mm=max-min;
	for (i = 0; i < N; i++) {
		heights[i] = (int)((alt_64) (means[i] - min) * MAX_H / (alt_64) (mm));
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
//software

// void take_mean() {
// 	int i, j;
// 	int num = BUF_SIZE / N;
// 	alt_64 sum = 0;
// 	alt_u32 fr;
// 	fr=alt_timestamp_freq();
// 	alt_timestamp_start();
// 	float tstart=(float)alt_timestamp()/(float)fr;
// 	for (j = 0; j < N; j++) {
// 		sum = 0;
// 		for (i = num * j; i < num * j + num - 1; i += 2) {
// 			sum += (alt_64)(l_buf[i] + l_buf[i + 1]);
// 		}
// 		means[j] = (int) (sum / num);
// 	}
// 	int max = 0;
// 	int min = means[0];
// 	for (i = 0; i < N; i++) {
// 		if (max < means[i]) {
// 			max = means[i];
// 		}
// 		if (min>means[i]){
// 			min = means[i];
// 		}
// 	}
// 	int mm=max-min;
// 	for (i = 0; i < N; i++) {
// 		heights[i] = (int)((alt_64) (means[i] - min) * MAX_H / (alt_64) (mm));
// 	}
// 	float tstop=(float)alt_timestamp()/(float)fr;
// 	printf("%f\n",tstop-tstart);
// }

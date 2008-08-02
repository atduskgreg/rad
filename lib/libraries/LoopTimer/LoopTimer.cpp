/*
  LoopTime.cpp - - Loop Timer library for Wiring/Arduino - Version 0.1
  
  Original code by JD Banrhart
  Original Arduino Library by BB Riley

*/


// include types & constants of Wiring core API
#include "WProgram.h"
#include "LoopTimer.h"

LoopTimer::LoopTimer()
{
	start_loop_time = 0;
	total_loop_time = 0;	
}	
    
// track method
void LoopTimer::track(void)
{
	total_loop_time = millis() - start_loop_time;
	start_loop_time = millis();	
}

// get total loop time:
unsigned long LoopTimer::get_total(void)
{
	return total_loop_time;
}


	
	
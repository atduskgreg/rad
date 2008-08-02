/*
  LoopTime.h - - Loop Timer library for Wiring/Arduino - Version 0.1
  
  Original code by JD Banrhart
  Original Arduino Library by BB Riley

*/

// ensure this library description is only included once
#ifndef LoopTimer_h
#define LoopTimer_h

// include types & constants of Wiring core API
#include "WConstants.h"

// library interface description
class LoopTimer {
  public:
    // constructors:
	LoopTimer();
	
    // track method
    void track(void);

    // mover method:
    unsigned long get_total(void);

  private:
	unsigned long start_loop_time;
	unsigned long total_loop_time;
};

#endif


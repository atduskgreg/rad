class InputOutputState < ArduinoPlugin
  
  # RAD plugins are c methods, directives, external variables and assignments and calls 
  # that may be added to the main setup method
  # function prototypes not needed since we generate them automatically
  
  # directives, external variables and setup assignments and calls can be added rails style (not c style)

# add to directives
#plugin_directives "#define ARY_SIZE 10"
  
# add to external variables
#external_variables "int *cur, *scan, *start, *end;", "int sm_ary[ARY_SIZE];"

# add the following to the setup method
#add_to_setup "scan = &sm_ary[0];", "cur = &sm_ary[0];", "start = &sm_ary[0];", "end = &sm_ary[ARY_SIZE-1];"

# return states of button and servo output stored in 
# array structs dbcd (debounce) and serv (servo)
# need error catch ...
# how about auto generating documentation from plugins
# at least showing 



int find_debounce_state(int input)
{
return dbce[input].state;
}

int find_debounce_read(int input)
{
return dbce[input].read;
}

int find_debounce_prev(int input)
{
return dbce[input].prev;
}

unsigned long find_debounce_time(int input)
{
return dbce[input].time;
}

int find_debounce_adjust(int input)
{
return dbce[input].adjust;
}

long unsigned find_servo_pulse_width(int input)
{
return serv[input].pulseWidth;
}

unsigned long find_servo_last_pulse(int input)
{
return serv[input].lastPulse;
}

unsigned long find_servo_start_pulse(int input)
{
return serv[input].startPulse;

}

unsigned long find_servo_refresh_time(int input)
{
return serv[input].refreshTime;
}

int find_servo_min(int input)
{
return serv[input].min;
}

int find_servo_max(int input)
{
return serv[input].max;

}


end
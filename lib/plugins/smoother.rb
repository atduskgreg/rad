class Smoother < ArduinoPlugin
  
  # RAD plugins are c methods, directives, external variables and assignments and calls 
  # that may be added to the main setup method
  # function prototypes not needed since we generate them automatically
  
  # directives, external variables and setup assignments and calls can be added rails style (not c style)

# add to directives
plugin_directives "#define ARY_SIZE 10"
  
# add to external variables
external_variables "int *cur, *scan, *start, *end;", "int sm_ary[ARY_SIZE];"

# add the following to the setup method
add_to_setup "scan = &sm_ary[0];", "cur = &sm_ary[0];", "start = &sm_ary[0];", "end = &sm_ary[ARY_SIZE-1];"

# add an element to the array and return the average

int smooth_average(int reading)
{
  int sum, cnt;
  cnt = 0;
  sum = 0;
  *cur = reading;
  cur++;
  for (scan = &sm_ary[0]; scan < &sm_ary[ARY_SIZE-1]; cnt++, scan++)
    sum += *scan;
  ptr_reset();
  Serial.print("smooth:sum: ");
  Serial.print(sum);
  Serial.print("smooth:cnt: ");
  Serial.print(cnt);
  Serial.print(" ");
  return sum/cnt;
}

void ptr_reset(void)
{
  if (cur == end)
  {
    cur = &sm_ary[0];
  }
}



end
class LCDPadding < ArduinoPlugin
  
# jdbarnhart
# 20080729
#
#
# purpose

# simple integer padding for lcd display pad
#
# example
# my_lcd.print pad_int_to_str 29, 5
# 
# result
# "   29"
  


static char* pad_int_to_str(int num, int length) 
{
    int i = 0;
    int start;
    char plain[20];
    char space[5] = "  ";
    char* pretty = "        ";    
    itoa(num, plain ,10);
    start = length - strlen(plain);
    while (i <= length) {
      if (i >= start)
        pretty[i] = plain[i - start];       
      else
        pretty[i] = space[0];
      i++;
    }
    return pretty;
}

static char* pad_int_to_str_w_zeros(int num, int length) 
{
    int i = 0;
    int start;
    char plain[20];
    char space[5] = "0 ";    
    char* pretty = "        ";    
    itoa(num, plain ,10);
    start = length - strlen(plain);
    while (i <= length) {
      if (i >= start)
        pretty[i] = plain[i - start];       
      else
        pretty[i] = space[0];
      i++;
    }
    return pretty;
}


end
class BitwiseOps < ArduinoPlugin
  
  # RAD plugins are c methods, directives, external variables and assignments and calls 
  # that may be added to the main setup method
  # function prototypes not needed since we generate them automatically
  
  # directives, external variables and setup assignments and calls can be added rails style (not c style)


  # add to directives
 
  # add to external variables
 
  # add the following to the setup method
  # add_to_setup 


int build_int(int hibyte, int lobyte) {
    return((hibyte << 8) + lobyte);
}

int i_shiftleft(int val, int shift) {
    return(val << shift);
}

int i_shiftright(int val, int shift) {
    return(val >> shift);
}

byte b_shiftleft(byte val, byte shift) {
    return(val << shift);
}

byte b_shiftright(byte val, byte shift) {
    return(val >> shift);
}

int bit_and(int val, int mask) {
    return(val & mask);
}

int bit_or(int val, int mask) {
    return(val | mask);
}

int bit_xor(int val, int mask) {
    return(val ^ mask);
}

int twos_comp(int val) {
    return((val ^ 0xffff) + 1);
}

end
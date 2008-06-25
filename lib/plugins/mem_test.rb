class MemTest < ArduinoPlugin
  
  # RAD plugins are c methods, directives, external variables and assignments and calls 
  # that may be added to the main setup method
  # function prototypes not needed since we generate them automatically
  
  # directives, external variables and setup assignments and calls can be added rails style (not c style)

  # add to directives
  #plugin_directives "#define EXAMPLE 10"

  # add to external variables
  # external_variables "int foo, bar"

  # add the following to the setup method
  # add_to_setup "foo = 1";, "bar = 1;" "sub_setup();"
  
  # one or more methods may be added and prototypes are generated automatically with rake make:upload
  
  # test the memory on your arduino uncommenting the following:
  # add_to_setup "memoryTest();"
  # or adding "memoryTest()" (no semicolon) to your main sketch

int memoryTest() {
  int byteCounter = 0; // initialize a counter
  byte *byteArray; // create a pointer to a byte array
  while ( (byteArray = (byte*) malloc (byteCounter * sizeof(byte))) != NULL ) {
   byteCounter++; // if allocation was successful, then up the count for the next try
    free(byteArray); // free memory after allocating it
 }

 free(byteArray); // also free memory after the function finishes"
 return byteCounter; // send back the highest number of bytes successfully allocated
}


end
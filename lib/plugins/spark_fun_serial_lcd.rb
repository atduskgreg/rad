class SparkFunSerialLcd < ArduinoPlugin
  
  # RAD plugins are c methods, directives, external variables and assignments and calls 
  # that may be added to the main setup method
  # function prototypes not needed since we generate them automatically
  
  # directives, external variables and setup assignments and calls can be added rails style (not c style)
  # hack from http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1209050315

  plugin_directives "#undef int", "#include <stdio.h>", "char _str[32];", "#define writeln(...) sprintf(_str, __VA_ARGS__); Serial.println(_str)"
  # add to directives
  #plugin_directives "#define EXAMPLE 10"

  # add to external variables
  external_variables "char status_message[40] = \"very cool\"", "char* msg[40]"

  # add the following to the setup method
  # add_to_setup "foo = 1";, "bar = 1;" "sub_setup();"
  
  # one or more methods may be added and prototypes are generated automatically with rake make:upload
  
# methods for sparkfun serial lcd SerLCD v2.5

void print_sensor_position_plus(int reading){


/*  writeln("sensor: %d ", reading); */
  Serial.print("sensor: ");
  Serial.print(reading);

  
}

void print_sensor_position(long pos){
  Serial.print(pos);
}

void lcd_first_line(){  //puts the cursor at line 0 char 0.
   Serial.print(0xFE, BYTE);   //command flag
   Serial.print(128, BYTE);    //position
}

void lcd_second_line(){  //puts the cursor at line 0 char 0.
   Serial.print(0xFE, BYTE);   //command flag
   Serial.print(192, BYTE);    //position
}

void selectLineOne(){  //puts the cursor at line 0 char 0.
   Serial.print(0xFE, BYTE);   //command flag
   Serial.print(128, BYTE);    //position
}
void selectLineTwo(){  //puts the cursor at line 0 char 0.
   Serial.print(0xFE, BYTE);   //command flag
   Serial.print(192, BYTE);    //position
}
void clearLCD(){
   Serial.print(0xFE, BYTE);   //command flag
   Serial.print(0x01, BYTE);   //clear command.
}
void backlightOn(){  //turns on the backlight
    Serial.print(0x7C, BYTE);   //command flag for backlight stuff
    Serial.print(157, BYTE);    //light level.
}

void set_backlight_level(int level){  //turns on the backlight
  if (level > 29)
    level = 29;
    Serial.print(0x7C, BYTE);   //command flag for backlight stuff
    Serial.print(157 + level, BYTE);    //light level.
}

void toggle_backlight(){  //turns off the backlight
    Serial.print(0x7C, BYTE);   //command flag for backlight stuff
    Serial.print("|");     //light level for off.
    Serial.print(1);
}

void set_splash(){
  selectLineOne();
  Serial.print(" Ruby + Auduino");
  selectLineTwo();
  Serial.print(" RAD 0.2.4+     ");
  Serial.print(0x7C, BYTE);   // decimal 124, command flag for backlight stuff
  Serial.print(10, BYTE);
}

void backlightOff(){  //turns off the backlight
    Serial.print(0x7C, BYTE);   // decimal 124, command flag for backlight stuff
    Serial.print(128, BYTE);     //light level for off.
}
void serCommand(){   // decimal 254, a general function to call the command flag for issuing all other commands   
  Serial.print(0xFE, BYTE);
}




    

end
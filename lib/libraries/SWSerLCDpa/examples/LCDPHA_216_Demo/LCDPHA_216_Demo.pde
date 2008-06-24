/*
  Arduino - code using SoftwareSerial to write to a Serial LCD,
  specifically a Wulfden K107 board utilizing an Anderson LCD 117
  controller chip.
  
  The code below specifies 19,200 baud, which is a special version
  I have from PHA. It works fine but if you deliver characters to 
  the chip to rapidly it will overrun the chip so a 2ms delay 
  between characters is executed plus a long pause after about 
  60-70 characters.
  
  At 9600 baud, a 1ms delay plus  the long pause suffices.
  
  I am considering writing a new Software Serial library and
  calling it SWSerLCDpa and have only the transmit routines for
  Writing to a device with no Receiver code. It will eliminate the
  need to specify a Receive pin and tie it up doing nothing and 
  the code will be a bit smaller.
  
  Brian B. Riley, Underhill Center, Vermont
  16 July 2007    <http://www.wulfden.org/TheShoppe.shtml>
  
*/


#include <SWSerLCDpa.h>

#define txPin 14
int  intensity = 0;

// set up a new serial port
SWSerLCDpa mySerial =  SWSerLCDpa(txPin);

int testval = 0;

void setup()  {
  
  pinMode(txPin, OUTPUT);  // define pin modes for tx pin
  
  mySerial.begin(9600);   // set the data rate for the SoftwareSerial port
  mySerial.clearscr();
  mySerial.setgeo(216);    // set chip geometry for a 2x16 display
  mySerial.setintensity(0x00);  // set backlight at max intensity
}

void loop() {

  mySerial.setintensity(intensity);  // set backlight at max intensity
 
  if (intensity < 0xC0)
    intensity += 0x40;
  else
    intensity = 0x00;
    
    
  mySerial.clearscr();                      // setup for simple lines of text
  mySerial.println(" Hello Arduino!");
  mySerial.print("ser_LCD display");
  
  delay(3000);                              // setup to print large number in various bases
  mySerial.clearscr();                      // at various xy positions

  mySerial.setxy(0,1);
  mySerial.print(4567, 5);

  delay(500);
  mySerial.setxy(6,0);
  mySerial.print(657, 2);
  delay (500);
  mySerial.setxy(9,1);
  mySerial.print(567, 3);
   delay(500);
  mySerial.setxy(0,0);
  mySerial.print("aBcDe");

  delay(2000);                             
  mySerial.clearscr();
  mySerial.setxy(4,0);                      // value in the original Softwae Serial code
  mySerial.print("-->");
  mySerial.print(testval++ % 10);
  mySerial.print("<--");

   delay(2000);                              // shows printable character set
  mySerial.clearscr();
  for (byte i = 0x30 ; i< 0x80 ; i++) {
     mySerial.print(i);
     delay(100);
  } 
           
  delay(2000);
  
  
    
}




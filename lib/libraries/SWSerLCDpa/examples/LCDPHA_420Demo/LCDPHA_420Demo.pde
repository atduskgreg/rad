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

#define txPin 14  // Analog 0 is also Digital 14, but any pin will do other than 0 ad 1

// set up a new serial port
SWSerLCDpa mySerial =  SWSerLCDpa(txPin);

int testval = 0;

void setup()  {
  
  pinMode(txPin, OUTPUT);        // define pin modes for tx pin
  
  mySerial.begin(9600);          // set the data rate for the SoftwareSerial port
  mySerial.clearscr();           // send any old command to 'prime the pump!"
  mySerial.setgeo(420);          // set chip geometry for a 4x20 display
  mySerial.setintensity(0x80);   // set backlight at max intensity

//mySerial.print("?C012345678901234567890");    // this comment line gives you character count grid for the lines below  
  mySerial.print("?C0====================");    // set custom splash screen
  delay(200);
  mySerial.print("?C1   The Shoppe at    ");
  delay(200);
  mySerial.print("?C2      Wulfden       ");
  delay(200);
  mySerial.print("?C3====================");
  delay(200);
  mySerial.print("?S2");
  delay(200);
  
}

void loop() {
  
  mySerial.clearscr();                      // setup for simple lines of text
  mySerial.setxy(0,0);
  mySerial.println(" Hello Arduino");
  mySerial.setxy(0,1);
  mySerial.println("   this is a");
  mySerial.setxy(0,2);
  mySerial.println("  serial  LCD");
  
  delay(5000);                              // setup to print large number in various bases
  mySerial.clearscr();                      // at various xy positions

  mySerial.setxy(6,3);
  mySerial.print(4567, 5);

  delay(500);
  mySerial.setxy(3,1);
  mySerial.print(457, 2);
  delay (500);
  mySerial.setxy(3,2);
  mySerial.print(4567, 3);
  delay(500);
  mySerial.setxy(10,0);
  mySerial.print("aBc");

  delay(2000);                              // I used this to find the bug when printing a zero
  mySerial.clearscr();
  mySerial.setxy(6,1);                      // value in the original Softwae Serial code
  mySerial.print("-->");
  mySerial.print(testval++ % 10);
  mySerial.print("<--");
 
        
  delay(2000);                             // setup to print Big NUmbers on a 4x20 display
  mySerial.clearscr();
 
 for (int i = 101 ; i < 300 ; i += 7) {
    mySerial.setxy(0,0);
    mySerial.intoBignum();
    mySerial.print(i, 10);
    mySerial.outofBignum();
    mySerial.print(i % 33);
    delay (300);
 }
    
  delay(2000);
  mySerial.print("?*");
  delay(2000);
  
  
    
}




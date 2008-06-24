/*
  Arduino - code using SoftwareSerial to write to a Serial LCD,
  specifically a Wulfden K107 board utilizing an Anderson LCD 117
  controller chip. At 9600 baud, a 1ms delay plus  various long 
  pauses suffice to keep uffer overrun in the controller.

  Brian B. Riley, Underhill Center, Vermont
  16 July 2007    <http://www.wulfden.org/TheShoppe.shtml>
  03 Sept 2007    modified for 2x24
  
*/

#include <SWSerLCDpa.h>

#define txPin    14
#define LEDpin   13

  int  testval  = 0;

  // create a new instance of a software serial port
  SWSerLCDpa mySerial =  SWSerLCDpa(txPin);

void setup()  {
  
  pinMode(txPin, OUTPUT);       // define pin modes for tx pin
  pinMode(LEDpin, OUTPUT);       // define pin modes for LED pin
 
  mySerial.begin(9600);         // set the data rate for the SoftwareSerial port
  mySerial.clearscr();          // 'prime the pump' - send something unimportant
                                // to kickstart the software serial in the LCD driver
  mySerial.setgeo(240);         // set chip geometry for a 2x24 display
 // mySerial.setintensity(0x80);  // set backlight at max intensity (if there is a backlight)
}

void loop() {
  
  digitalWrite(LEDpin, HIGH);               // light the LED
  mySerial.clearscr();                      // setup for simple lines of text
  mySerial.println("             Hello Arduino!");
  mySerial.print("          2x40  ser_LCD display");
  
  delay(3000);                              // setup to print large number in various bases
  mySerial.clearscr();                      // at various xy positions

  digitalWrite(LEDpin, LOW);               // turn the LED off

  mySerial.setxy(0,1);                      // sest cursor at (x,y)
  mySerial.print(4567, 5);                  // prints that decinmal number in base 5

  delay(500);
  mySerial.setxy(9,0);
  mySerial.print(657, 2);
  delay (500);
  mySerial.setxy(29,1);
  mySerial.print(567, 3);
  delay(500);
  mySerial.setxy(23,0);
  mySerial.print("aBcDe");
  delay (500);
  mySerial.setxy(20,1);
  mySerial.print("urbaop");

  digitalWrite(LEDpin, HIGH);               // light the LED

  delay(2000);                             
  mySerial.clearscr();
  mySerial.setxy(18,0);                    
  mySerial.print("-->");
  mySerial.print(testval++ % 10);
  mySerial.print("<--");

  delay(2000);                           // shows printable character set
  mySerial.clearscr();
  for (byte i = 0x30 ; i< 0x80 ; i++) {
     mySerial.print(i);
     delay(100);
  } 

  digitalWrite(LEDpin, LOW);               // turn the LED off
          
  delay(2000);                            // wait 2 seconds (2000 ms)
  
}




/*************************************************************************************
 *        Demonstration Program for I2C Serial EEPROM Library
 * ----------------------------------------------------------------------------------
 *       Arduino Library Program Code for Serial I2C EEPROMS - I2CEEPROM.cpp
 *  Adapted from an unsigned procedure on the Playground that had never been made
 *  into a library. Adaptation by Brian Riley, Underhill Center, VT, USA
 *                         <brianbr@wulfden.org> 
 * ----------------------------------------------------------------------------------
 *  Simple read & write to a 24LCxxx EEPROM using the Wire library. The library will
 *  work with the 24LC16B (2KB), through and including 24LC512 (64KB). There is no way
 *  to tell what chip is there and consequently what the ending address is. So
 *  there is no address checking code, the programmer will have to keep track of his
 *  address count in his own program code. A read of a non-existant location will 
 *  return the value 0xFF, but there is no way to tell if its an 0xFF or a read
 *  of non-existant memory
 *
 *  Functions for R/W of single byte or a page of bytes. Block/Page reads are 
 *  limited to 28 bytes due to the Wire library buffer being 32 bytes.
 *
 *   Hardware Setup:
 *                    _ _                                 
 *   Arduino GND- A0-|oU |-Vcc  to Arduino Vcc
 *   Arduino GND- A1-|   |-WP   to GND for now. Set to Vcc for write protection.
 *   Arduino GND- A2-|   |-SCL  to Arduino 5
 *   Arduino GND-Vss-|   |-SDA  to Arduino 4
 *                    ---       (A2, A1, A0 to GND for 1010000 (0x50) address.)
 *
 *  Pulling any pin A2,A1,A0 to Vcc adds to base address 0x50, giving an address
 *  range for 8 devices 0x50 through 0x57, The code below assumes the 0x50, so
 *  when creating the instance one simply plugs in the relative address, a digit 
 *  from 0 to 7. Now, the most common physical configuration is a single chip
 *  at device address 0, so instantiating with no device address assumes a '0' 
 *  which becomes address 0x50 .
 *
 ************************************************************************************/

#include <Wire.h>
#include <I2CEEPROM.h>

#define DEVICE 0           // I2C Buss address of 24LC256 256K EEPROM

// I2CEEPROM mem0 = I2CEEPROM(); // defaults to address 0 --> 0x50
I2CEEPROM mem0 = I2CEEPROM(DEVICE);


void setup(){
  Wire.begin();                    // join I2C bus (address optional for master)
  Serial.begin(9600);
  Serial.println("\n----------------\n");

// TESTS FOR EACH FUNCTION BEGIN HERE
  Serial.println("Writing Test:");
  for (int i=0; i<32; i++){            // loop for first 20 slots
    mem0.write_byte(i,83-i);   // write address + 65 A or 97 a
    Serial.print(". ");
    delay(5);                         // NEED THIS DELAY! (tests suggest it can be as
                                      // small as delay(3) -- BBR
  }

  Serial.println("");
  delay(500);
  Serial.println("Reading Test:");
  for (int i=0; i<32; i++){            // loop for first 20 slots
    Serial.print(mem0.read_byte(i),BYTE);
    Serial.print(" ");
  }


  // setup for page tests . . .
  byte PageData[30];                   // array that will hold test data for a page
  byte PageRead[30];                   // array that will hold result of data for a page
  for (int i=0; i<30; i++){            // zero both arrays for next test
    PageData[i] = 0;    
    PageRead[i] = 0;
  }
  Serial.println("");
  for (int i=0; i<30; i++) PageData[i] = i+66;  // fill up array for next test char 33 = !

  Serial.println("Writing Page Test:");
  Serial.println(millis());
  mem0.write_page(100, PageData, 28 ); // 28 bytes/page is max
  Serial.println(millis());

  Serial.println("Reading Page Test:");
  mem0.read_buffer(100, PageRead, 28);
  for (int i=0; i<28; i++){
    Serial.print(PageRead[i],BYTE);    // display the array read
    Serial.print(" ");
  }
  
}

void loop(){
}


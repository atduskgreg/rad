/*************************************************************************************
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

extern "C" {
#include "WConstants.h"
#include <../Wire/Wire.h>
}
#include "I2CEEPROM.h"

/********************************
 *  I2CEEPROM()  - constructors
 ********************************/

I2CEEPROM::I2CEEPROM() {
  _device_address = 0x50;
}

I2CEEPROM::I2CEEPROM(int addr) {
  _device_address = addr + 0x50;
}

/********************************
 *  write_byte()
 ********************************/

void I2CEEPROM::write_byte( unsigned int eeaddress, byte data ) {
  int rdata = data;
  send_preamble(eeaddress);
  Wire.send(rdata);
  Wire.endTransmission();
  delay(3);					// needed to sllow tiem for the write
}

/***************************************************************************
 * write_page()
 * Address is a page address, 6-bit (63). More and end will wrap
 * around. But data can be maximum of 28 bytes, because the Wire library
 * has a buffer of 32 bytes
 ***************************************************************************/

void I2CEEPROM::write_page( unsigned int eeaddresspage, byte* data, int length ) {
  send_preamble(eeaddresspage);
  for ( int c = 0; c < length; c++)
    Wire.send(data[c]);
  Wire.endTransmission();
  delay(3*length);                           // need some delay
}

/********************************
 *  read_byte()
 ********************************/

byte I2CEEPROM::read_byte( unsigned int eeaddress ) {
  byte rdata = 0xFF;
  send_preamble(eeaddress);
  Wire.endTransmission();
  Wire.requestFrom(_device_address,1);
  if (Wire.available()) rdata = Wire.receive();
  return rdata;
}

/************************************************
 *  write_byte()
 * should not read more than 28 bytes at a time!
 ************************************************/
 
void I2CEEPROM::read_buffer( unsigned int eeaddress, byte *buffer, int length ) {
  send_preamble(eeaddress);
  Wire.endTransmission();
  Wire.requestFrom(_device_address,length);
  for ( int c = 0; c < length; c++ )
    if (Wire.available()) buffer[c] = Wire.receive();
}


/************************************************
 *  send_preamble()
 * private function - group repetitive stuff
 ************************************************/

void I2CEEPROM::send_preamble( unsigned int eeaddress ) {
  Wire.beginTransmission(_device_address);
  Wire.send((int)(eeaddress >> 8)); // Address High Byte
  Wire.send((int)(eeaddress & 0xFF)); // Address Low Byte
}



 

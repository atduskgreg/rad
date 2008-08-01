
/*************************************************************************************
 *       Arduino Library Header File for Serial I2C EEPROMS - I2CEEPROM.h
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

// ensure this library description is only included once
#ifndef I2CEEPROM_h
#define I2CEEPROM_h
 
// include types & constants of Wiring core API
#include <WConstants.h>

// include types & constants of Wire i2c lib
#include <../Wire/Wire.h>

// library interface description
class I2CEEPROM
{
  // user-accessible "public" interface
  public:
    I2CEEPROM();
    I2CEEPROM(int);

	void write_byte( unsigned int, byte );

	void write_page( unsigned int, byte*, int );

	byte read_byte( unsigned int );

	void read_buffer( unsigned int, byte*, int );

  // library-accessible "private" interface
  private:
    int _device_address;
	void send_preamble(unsigned int);
};


#endif
 

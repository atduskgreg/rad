/*
  SWSerLCDsf.cpp - Software serial to SparkFun controller chip based
  LCD display library Adapted from SoftwareSerial.cpp (c) 2006 David A. Mellis
  by Brian B. Riley, Underhill Center, Vermont, USA, July 2008

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

/******************************************************************************
 * Includes
 ******************************************************************************/

#include "WConstants.h"
#include "SWSerLCDsf.h"

/******************************************************************************
 * Definitions
 ******************************************************************************/

/******************************************************************************
 * Constructors
 ******************************************************************************/

SWSerLCDsf::SWSerLCDsf(uint8_t transmitPin)
{
  _transmitPin = transmitPin;
  _baudRate = 0;
  _rows = 2;
  _cols = 16;
  _geometry = 0;
}

SWSerLCDsf::SWSerLCDsf(uint8_t transmitPin, int geometry)
{
  _transmitPin = transmitPin;
  _baudRate = 0;
  pinMode(_transmitPin, OUTPUT); 
  _rows = 2;
  _cols = 16;
  _geometry = geometry;
}


/******************************************************************************
 * User API
 ******************************************************************************/

void SWSerLCDsf::begin(long speed)
{
  _baudRate = speed;
  _bitPeriod = 1000000 / _baudRate;

  digitalWrite(_transmitPin, HIGH);
  delayMicroseconds( _bitPeriod); // if we were low this establishes the end
  delay(50);
  if (_geometry)
  	setgeo(_geometry);
}

void SWSerLCDsf::print(uint8_t b)
{
  if (_baudRate == 0)
    return;
    
  int bitDelay = _bitPeriod - clockCyclesToMicroseconds(50); // a digitalWrite is about 50 cycles
  byte mask;

  digitalWrite(_transmitPin, LOW);
  delayMicroseconds(bitDelay);

  for (mask = 0x01; mask; mask <<= 1) {
    if (b & mask){ // choose bit
      digitalWrite(_transmitPin,HIGH); // send 1
    }
    else{
      digitalWrite(_transmitPin,LOW); // send 1
    }
    delayMicroseconds(bitDelay);
  }

  digitalWrite(_transmitPin, HIGH);
  delayMicroseconds(bitDelay);
}

void SWSerLCDsf::print(const char *s)
{
  while (*s) {
    print(*s++);
    delay(1);
  }
}

void SWSerLCDsf::print(char c)
{
  print((uint8_t) c);
}

void SWSerLCDsf::print(int n)
{
  print((long) n);
}

void SWSerLCDsf::print(unsigned int n)
{
  print((unsigned long) n);
}

void SWSerLCDsf::print(long n)
{
  if (n < 0) {
    print('-');
    n = -n;
  }
  printNumber(n, 10);
}

void SWSerLCDsf::print(unsigned long n)
{
  printNumber(n, 10);
}

void SWSerLCDsf::print(long n, int base)
{
  if (base == 0)
    print((char) n);
  else if (base == 10)
    print(n);
  else
    printNumber(n, base);
}

// -------- Spark Fun unique codes -------------------------

void SWSerLCDsf::clearscr(void)
{
  print((uint8_t) 0xFE);
  print((uint8_t) 0x01);
  delay(100);
}

void SWSerLCDsf::clearscr(const char *s)
{
	clearscr();
	print(s);
}

void SWSerLCDsf::clearscr(int n)
{
	clearscr();
	print(n);
}

void SWSerLCDsf::clearscr(long n, int b)
{
	clearscr();
	print(n,b);
}

void SWSerLCDsf::home(void)
{
	setxy(0, 0);
}

void SWSerLCDsf::home(const char *s)
{
	home();
	print(s);
}

void SWSerLCDsf::home(int n)
{
	home();
	print(n);
}

void SWSerLCDsf::home(long n, int b)
{
	home();
	print(n,b);
}



void SWSerLCDsf::setxy(byte x, byte y)
{
  byte posvar;
  
  switch (y) {
    case 0:
  		posvar = 128 + x;
  		break;
  	case 1:
  		posvar = 192+ x;
  		break;
  	case 2:
  		posvar = ((_cols == 16) ? 144 : 148) + x;
  		break;
  	case 3:
  		posvar = ((_cols == 16) ? 208 : 212) + x;
  		break;
  }			
  print((uint8_t) 0xFE);
  print((uint8_t) posvar);
}

void SWSerLCDsf::setxy(byte x, byte y, const char *s)
{
	setxy(x,y);
	print(s);
}

void SWSerLCDsf::setxy(byte x, byte y, int n)
{
	setxy(x,y);
	print(n);
}

void SWSerLCDsf::setxy(byte x, byte y, long n, int b)
{
	setxy(x,y);
	print(n,b);
}



void SWSerLCDsf::setcmd(byte code, byte cmd)
{
  print((uint8_t) code);
  print((uint8_t) cmd);	
}


void SWSerLCDsf::setgeo(int geometry)
{
  byte	rows=6, cols=4;
  switch (geometry) {
    case 216:
  	  break;
    case 220:
	    _cols = 20;
  		cols = 3;
  		break;
    case 416:
    	rows = 5;
  		_rows = 4;
  		break;
  	case 420:
	    _rows = 4;
    	_cols = 20;
  		cols = 3;
  		rows = 5;
  		break;
  	default:
	  	return;
	  	break;
  }
  print((uint8_t) 0x7C);
  print((uint8_t) rows);
  print((uint8_t) 0x7C);
  print((uint8_t) cols);
  delay(200);
}

void SWSerLCDsf::setintensity(int intensity)
{
  if (intensity > 29)
  	intensity = 29;
  print((uint8_t) 0x7C);
  print((uint8_t) (0x80 + intensity));
  delay(100);
}





// Private Methods /////////////////////////////////////////////////////////////

void SWSerLCDsf::printNumber(unsigned long n, uint8_t base)
{
  unsigned char buf[8 * sizeof(long)]; // Assumes 8-bit chars. 
  unsigned long i = 0;  	

  if (n == 0) {
    print('0');
    return;
  } 

  while (n > 0) {
    buf[i++] = n % base;
    n /= base;
  }

  for (; i > 0; i--)
    print((char) (buf[i - 1] < 10 ? '0' + buf[i - 1] : 'A' + buf[i - 1] - 10));
  
  delay(8);
  
}

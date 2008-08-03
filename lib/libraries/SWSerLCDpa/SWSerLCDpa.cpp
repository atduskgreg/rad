/*
  SWSerLCDpa.cpp - Software serial to Peter Anderson controller chip based
  LCD display library Adapted from SoftwareSerial.cpp (c) 2006 David A. Mellis
  by Brian B. Riley, Underhill Center, Vermont, USA, July 2007

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
#include "SWSerLCDpa.h"

/******************************************************************************
 * Definitions
 ******************************************************************************/

/******************************************************************************
 * Constructors
 ******************************************************************************/

SWSerLCDpa::SWSerLCDpa(uint8_t transmitPin)
{
  _transmitPin = transmitPin;
  _baudRate = 0;
  pinMode(_transmitPin, OUTPUT);
  _geometry = 0;
}

SWSerLCDpa::SWSerLCDpa(uint8_t transmitPin, int geometry)
{
  _transmitPin = transmitPin;
  _baudRate = 0;
  pinMode(_transmitPin, OUTPUT); 
  _geometry = geometry;
}



/******************************************************************************
 * User API
 ******************************************************************************/

void SWSerLCDpa::begin(long speed)
{
  _baudRate = speed;
  _bitPeriod = 1000000 / _baudRate;

  digitalWrite(_transmitPin, HIGH);
  delayMicroseconds( _bitPeriod); // if we were low this establishes the end
  delay(50);
  if (_geometry)
	setgeo(_geometry);
}

void SWSerLCDpa::print(uint8_t b)
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

void SWSerLCDpa::print(const char *s)
{
  while (*s) {
    print(*s++);
    delay(2);
  }
}

void SWSerLCDpa::print(char c)
{
  print((uint8_t) c);
}

void SWSerLCDpa::print(int n)
{
  print((long) n);
}

void SWSerLCDpa::print(unsigned int n)
{
  print((unsigned long) n);
}

void SWSerLCDpa::print(long n)
{
  if (n < 0) {
    print('-');
    n = -n;
  }
  printNumber(n, 10);
}

void SWSerLCDpa::print(unsigned long n)
{
  printNumber(n, 10);
}

void SWSerLCDpa::print(long n, int base)
{
  if (base == 0)
    print((char) n);
  else if (base == 10)
    print(n);
  else
    printNumber(n, base);
}

// -------- PHA unique codes -------------------------


void SWSerLCDpa::clearscr(void)
{
  print("?f");
  delay(30);
}

void SWSerLCDpa::clearscr(const char *s)
{
	clearscr();
    print(s);
}

void SWSerLCDpa::clearscr(int n)
{
	clearscr();
    print(n);
}

void SWSerLCDpa::clearscr(long n, int base)
{
	clearscr();
	print(n, base);
}


void SWSerLCDpa::clearline(int line)
{
  setxy(0,line);
  print("?l");
  delay(20);
}

void SWSerLCDpa::clearline(int line, const char *s)
{
  clearline(line);
  print(s);
}

void SWSerLCDpa::clearline(int line, int n)
{
  clearline(line);
  print(n);
}

void SWSerLCDpa::clearline(int line, long n, int base)
{
	clearline(line);
	print(n, base);
}

void SWSerLCDpa::setxy(int x, int y)
{
  print("?y");
  print(y);	
  print("?x");
  if (x < 10)
    print('0');
  print(x);
  delay(10);
}

void SWSerLCDpa::setxy(int x, int y, const char *s)
{
	setxy(x,y);
	print(s);
}

void SWSerLCDpa::setxy(int x, int y, int n)
{
	setxy(x,y);
	print(n);
}

void SWSerLCDpa::setxy(int x, int y, long n, int base)
{
	setxy(x,y);
	print(n, base);
}

void SWSerLCDpa::home(void)
{
  print("?a");
  delay(10);
}

void SWSerLCDpa::home(const char *s)
{
  home();
  print(s);
}

void SWSerLCDpa::home(int n)
{
  home();
  print(n);
}

void SWSerLCDpa::home(long n, int base)
{
	home();
	print(n, base);
}

void SWSerLCDpa::setgeo(int geometry)
{
	print("?G");
	print(geometry);
	delay(200);
}

void SWSerLCDpa::setintensity(int intensity)
{
  print("?B");
  if (intensity < 16)
  	print('0');
  print(intensity, 16);
  delay(200);
}

void SWSerLCDpa::intoBignum(void)
{
  print("?>3");
}

void SWSerLCDpa::outofBignum(void)
{
  print("?<");
}

// Private Methods /////////////////////////////////////////////////////////////

void SWSerLCDpa::printNumber(unsigned long n, uint8_t base)
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

  for (; i > 0; i--) {
    print((char) (buf[i - 1] < 10 ? '0' + buf[i - 1] : 'A' + buf[i - 1] - 10));
	delay(2);
  }
  
}

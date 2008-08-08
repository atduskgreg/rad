/*
  SWSerLCDsf.h - Software serial to SparkFun controller chip based
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

#ifndef SWSerLCDsf_h
#define SWSerLCDsf_h

#include <inttypes.h>
 
class SWSerLCDsf
{
  private:
    uint8_t _transmitPin;
    long _baudRate;
    int _bitPeriod;
    byte _rows;
    byte _cols;
    int _geometry;
    void printNumber(unsigned long, uint8_t);

  public:
    SWSerLCDsf(uint8_t);
    SWSerLCDsf(uint8_t, int);
    void begin(long);
    void print(char);
    void print(const char[]);
    void print(uint8_t);
    void print(int);
    void print(unsigned int);
    void print(long);
    void print(unsigned long);
    void print(long, int);
	void clearscr(void);
	void clearscr(const char[]);
	void clearscr(int);
	void clearscr(long, int);
	void home(void);
	void home(const char[]);
	void home(int);
	void home(long, int);
	void setxy(byte, byte);
	void setxy(byte, byte, const char[]);
	void setxy(byte, byte, int);
	void setxy(byte, byte, long, int);
	void setgeo(int);
	void setintensity(int);
	void setcmd(byte, byte);
};

#endif


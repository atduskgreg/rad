/*
  SWSerLCDpa.h - Software serial to Peter Anderson controller chip based
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

#ifndef SWSerLCDpa_h
#define SWSerLCDpa_h

#include <inttypes.h>
 
class SWSerLCDpa
{
  private:
    uint8_t _transmitPin;
    long _baudRate;
    int _bitPeriod;
    int _geometry;
    void printNumber(unsigned long, uint8_t);
  public:
    SWSerLCDpa(uint8_t, int); 
    SWSerLCDpa(uint8_t);
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
	void clearline(int);
	void clearline(int, const char[]);
	void clearline(int, int);
	void clearline(int, long, int);
	void home(void);
	void home(const char[]);
	void home(int);
	void home(long, int);
	void setxy(int, int);
	void setxy(int, int, const char[]);
	void setxy(int, int, int);
	void setxy(int, int, long, int);
	void setgeo(int);
	void setintensity(int);
	void intoBignum(void);
	void outofBignum(void);
};

#endif


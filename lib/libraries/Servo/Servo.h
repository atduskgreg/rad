/*
  Servo.h - Arduino Software Servo Library
  Author: ????
  Modified: Brian Riley <brianbr@wulfden.org> Jun/Jul 2008
  Copyright (c) 2007 David A. Mellis.  All right reserved.

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
#ifndef SERVO_IS_IN
#define SERVO_IS_IN

#include <inttypes.h>
#include <wiring.h>

#define	DEFLT_MINP	34
#define	DEFLT_MAXP	150

class Servo
{
  private:
    uint8_t pin;
    uint8_t angle;       // in degrees
    uint16_t pulse0;     // pulse width in TCNT0 counts
    uint8_t min16;       // minimum pulse, 16uS units  (default is DEFLT_MINP)
    uint8_t max16;       // maximum pulse, 16uS units, 0-4ms range (default is DEFLT_MAXP)
    class Servo *next;
    static Servo* first;
    void write(int);         // specify the angle in degrees, 0 to 180
 public:
    Servo();
    uint8_t attach(int);     // attach to a pin, sets pinMode, returns 0 on failure, won't
                             // position the servo until a subsequent write() happens
    uint8_t attach(int,int);
                             // same, except position is also is specified
    uint8_t attach(int,uint16_t,uint16_t);
                             // same, except min/max pulse is specified
    uint8_t attach(int,int,uint16_t,uint16_t);
                             // same, except position and min/max pulse is specified
    void detach();
    void position(int);		 // enter an angle from 0 to 180
    void speed(int);		 // enter a speed from -90 to +90
    uint8_t read();
    uint8_t attached();
    static void refresh();   // must be called at least every 50ms or so to keep servo alive
                             // you can call more often, it won't happen more than once 
                             // every 20ms
};

#endif

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

#include "WConstants.h"
#include <Servo.h>

Servo *Servo::first;

#define NO_ANGLE (0xff)

Servo::Servo() : pin(0),angle(NO_ANGLE),pulse0(0),min16(DEFLT_MINP),max16(DEFLT_MAXP),next(0)
{}


uint8_t Servo::attach(int pinArg)
{
    pin = pinArg;
    angle = NO_ANGLE;
    pulse0 = 0;
    next = first;
    first = this;
    digitalWrite(pin,0);
    pinMode(pin,OUTPUT);
    return 1;
}

uint8_t Servo::attach(int pinArg, int angleArg)
{
	attach(pinArg);
	write(angleArg);
    return 1;
}


uint8_t Servo::attach(int pinArg, uint16_t minp, uint16_t maxp)
{
	attach(pinArg);
    min16	= minp/16;
    max16	= maxp/16;
    return 1;
}

uint8_t Servo::attach(int pinArg, int angleArg, uint16_t minp, uint16_t maxp)
{
	attach(pinArg);
    min16	= minp/16;
    max16	= maxp/16;
	write(angleArg);
    return 1;
}

void Servo::detach()
{
    for ( Servo **p = &first; *p != 0; p = &((*p)->next) ) {
	if ( *p == this) {
	    *p = this->next;
	    this->next = 0;
	    return;
	}
    }
}

void Servo::write(int angleArg)
{
    if ( angleArg < 0) angleArg = 0;
    if ( angleArg > 180) angleArg = 180;
    angle = angleArg;
    // bleh, have to use longs to prevent overflow, could be tricky if always a 16MHz clock, but not true
    // That 64L on the end is the TCNT0 prescaler, it will need to change if the clock's prescaler changes,
    // but then there will likely be an overflow problem, so it will have to be handled by a human.
    pulse0 = (min16*16L*clockCyclesPerMicrosecond() + (max16-min16)*(16L*clockCyclesPerMicrosecond())*angle/180L)/64L;
}

void Servo::position(int angleArg)
{
    write(angleArg);
}

void Servo::speed(int speedVal)
{
	speedVal += 90;
    write(speedVal);
}

uint8_t Servo::read()
{
    return angle;
}

uint8_t Servo::attached()
{
    for ( Servo *p = first; p != 0; p = p->next ) {
	if ( p == this) return 1;
    }
    return 0;
}

/*************************************************
 * refresh() - the heart of the method
 *************************************************/

void Servo::refresh()
{
    uint8_t count = 0, i = 0;
    uint16_t base = 0;
    Servo *p;
    static unsigned long lastRefresh = 0;
    unsigned long m = millis();

    // if we haven't wrapped millis, and 20ms have not passed,
    // then don't do anything
    
    if ( m >= lastRefresh && m < lastRefresh + 20) return;
    lastRefresh = m;

    for ( p = first; p != 0; p = p->next ) if ( p->pulse0) count++;
    
    if ( count == 0) return;
  
    // gather all the servos in an array
    
    Servo *s[count];
 
 	for ( p = first; p != 0; p = p->next ) if ( p->pulse0) s[i++] = p;

    // bubblesort the servos by pulse time, ascending order
    
    for(;;) {
		uint8_t moved = 0;
		for ( i = 1; i < count; i++) {
	    	if ( s[i]->pulse0 < s[i-1]->pulse0) {
				Servo *t = s[i];
				s[i] = s[i-1];
				s[i-1] = t;
				moved = 1;
	    	}
		}
		if ( !moved) break;
    }
  
    /*********************************************************************
     * Turn on all the pins
     * Note the timing error here... when you have many servos going, the
     * ones at the front will get a pulse that is a few microseconds too long.
     * Figure about 4uS/servo after them. This could be compensated, but I feel
     * it is within the margin of error of software servos that could catch
     * an extra interrupt handler at any time.
     ********************************************************************/

    for ( i = 0; i < count; i++) digitalWrite( s[i]->pin, 1);

    uint8_t start = TCNT0;
    uint8_t now = start;
    uint8_t last = now;
  
    // Now wait for each pin's time in turn..
    
    for ( i = 0; i < count; i++) {
		uint16_t go = start + s[i]->pulse0;
    
		// loop until we reach or pass 'go' time

		for (;;) {
	    	now = TCNT0;
	    	if ( now < last) base += 256;
	    	last = now;
  
	    	if ( base+now > go) {
				digitalWrite( s[i]->pin,0);
				break;
	    	}
		}
    }
}

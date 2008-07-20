/*

// -----------------------------------------------------------
// This is an 'abbreviated' OneWire Library with functions
// only to handle a single device per line, no ROM-IDs will 
// be read. It is a subset of the original fom the Arduino
// IDE - Brian Riley, Underhill Center, VT July 2008
// -----------------------------------------------------------
Copyright (c) 2007, Jim Studt

Updated to work with arduino-0008 and to include skip() as of
2007/07/06. --RJL20

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Much of the code was inspired by Derek Yerger's code, though I don't
think much of that remains.  In any event that was..
    (copyleft) 2006 by Derek Yerger - Free to distribute freely.

The CRC code was excerpted and inspired by the Dallas Semiconductor 
sample code bearing this copyright.
//---------------------------------------------------------------------------
// Copyright (C) 2000 Dallas Semiconductor Corporation, All Rights Reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY,  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL DALLAS SEMICONDUCTOR BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// Except as contained in this notice, the name of Dallas Semiconductor
// shall not be used except as stated in the Dallas Semiconductor
// Branding Policy.
//--------------------------------------------------------------------------
*/

#include "OneWire.h"

extern "C" {
#include "WConstants.h"
#include <avr/io.h>
#include "pins_arduino.h"
}


OneWire::OneWire( uint8_t pinArg)
{
    pin = pinArg;
    port = digitalPinToPort(pin);
    bitmask =  digitalPinToBitMask(pin);
    outputReg = portOutputRegister(port);
    inputReg = portInputRegister(port);
    modeReg = portModeRegister(port);
}

//
// Perform the onewire reset function.  We will wait up to 250uS for
// the bus to come high, if it doesn't then it is broken or shorted
// and we return a 0;
//
// Returns 1 if a device asserted a presence pulse, 0 otherwise.
//
uint8_t OneWire::reset() {
    uint8_t r;
    uint8_t retries = 125;

    // wait until the wire is high... just in case
    pinMode(pin,INPUT);
    do {
	if ( retries-- == 0) return 0;
	delayMicroseconds(2); 
    } while( !digitalRead( pin));
    
    digitalWrite(pin,0);   // pull low for 500uS
    pinMode(pin,OUTPUT);
    delayMicroseconds(500);
    pinMode(pin,INPUT);
    delayMicroseconds(65);
    r = !digitalRead(pin);
    delayMicroseconds(490);
    return r;
}

//
// Write a bit. Port and bit is used to cut lookup time and provide
// more certain timing.
//
void OneWire::write_bit(uint8_t v) {
    static uint8_t lowTime[] = { 55, 5 };
    static uint8_t highTime[] = { 5, 55};
    
    v = (v&1);
    *modeReg |= bitmask;  // make pin an output, do first since we
                          // expect to be at 1
    *outputReg &= ~bitmask; // zero
    delayMicroseconds(lowTime[v]);
    *outputReg |= bitmask; // one, push pin up - important for
                           // parasites, they might start in here
    delayMicroseconds(highTime[v]);
}

//
// Read a bit. Port and bit is used to cut lookup time and provide
// more certain timing.
//
uint8_t OneWire::read_bit() {
    uint8_t r;
    
    *modeReg |= bitmask;    // make pin an output, do first since we expect to be at 1
    *outputReg &= ~bitmask; // zero
    delayMicroseconds(1);
    *modeReg &= ~bitmask;     // let pin float, pull up will raise
    delayMicroseconds(5);          // A "read slot" is when 1mcs > t > 2mcs
    r = ( *inputReg & bitmask) ? 1 : 0; // check the bit
    delayMicroseconds(50);        // whole bit slot is 60-120uS, need to give some time
    
    return r;
}

//
// Write a byte. The writing code uses the active drivers to raise the
// pin high, if you need power after the write (e.g. DS18S20 in
// parasite power mode) then set 'power' to 1, otherwise the pin will
// go tri-state at the end of the write to avoid heating in a short or
// other mishap.
//
void OneWire::write(uint8_t v, uint8_t power) {
    uint8_t bitMask;
    
    for (bitMask = 0x01; bitMask; bitMask <<= 1) {
	OneWire::write_bit( (bitMask & v)?1:0);
    }
    if ( !power) {
	pinMode(pin,INPUT);
	digitalWrite(pin,0);
    }
}

//
// Read a byte
//
uint8_t OneWire::read() {
    uint8_t bitMask;
    uint8_t r = 0;
    
    for (bitMask = 0x01; bitMask; bitMask <<= 1) {
	if ( OneWire::read_bit()) r |= bitMask;
    }
    return r;
}


//
// Do a ROM skip
//
void OneWire::skip()
{
    write(0xCC,0);         // Skip ROM
}

void OneWire::depower()
{
    pinMode(pin,INPUT);
}


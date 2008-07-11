#ifndef FREQUENCYTIMER2_IS_IN
#define FREQUENCYTIMER2_IS_IN

/*
  FrequencyTimer2.h - A frequency generator and interrupt generator library
  Author: Jim Studt, jim@federated.com
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


#include <wiring.h>

class FrequencyTimer2
{
  private:
    static uint8_t enabled;
  public:
    static void (*onOverflow)(); // not really public, but I can't work out the 'friend' for the SIGNAL
    
  public:
    static void setPeriod(unsigned long);
    static unsigned long getPeriod();
    static void setOnOverflow( void (*)() );
    static void enable();
    static void disable();
};

#endif

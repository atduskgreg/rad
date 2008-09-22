#include <avr/io.h>
#include "WProgram.h"
#include "AFSoftSerial.h"
#include "AF_XPort.h"

static AFSoftSerial xportserial = AFSoftSerial(0,0); // we dont know the pins yet

AF_XPort::AF_XPort(uint8_t rx, uint8_t tx, uint8_t reset, uint8_t dtr, uint8_t rts, uint8_t cts) {
  rxpin = rx;
  txpin = tx;
  resetpin = reset;
  if (resetpin) {
    pinMode(resetpin, OUTPUT);
    digitalWrite(resetpin, HIGH);
  }
  
  dtrpin = dtr;
  rtspin = rts;
  ctspin = cts;
  if (ctspin) {
    digitalWrite(ctspin, HIGH);
    pinMode(ctspin, OUTPUT);
  }
}

void AF_XPort::begin(uint16_t b) {
  xportserial.setTX(rxpin);
  xportserial.setRX(txpin);
  xportserial.begin(b);
}

uint8_t AF_XPort::reset(void) {
  char d;

  if (resetpin) {
    digitalWrite(resetpin, LOW);
    delay(50);
    digitalWrite(resetpin, HIGH);
  }

 // wait for 'D' for disconnected
  if (serialavail_timeout(5000)) { // 3 second timeout 
    d = xportserial.read();
    //Serial.print("Read: "); Serial.print(d, HEX);
    if (d != 'D'){
      return ERROR_BADRESP;
    } else {
      return 0;
    }
  }
  return ERROR_TIMEDOUT;
}

uint8_t AF_XPort::disconnected(void) {
  if (dtrpin != 0) {
     return digitalRead(dtrpin);
  } 
  return 0;
}


uint8_t AF_XPort::connect(char *ipaddr, long port) {
  char ret;
  
  xportserial.print('C');
  xportserial.print(ipaddr);
  xportserial.print('/');
  xportserial.println(port);
  // wait for 'C'
  if (serialavail_timeout(3000)) { // 3 second timeout 
    ret = xportserial.read();
    //Serial.print("Read: "); Serial.print(d, HEX);
    if (ret != 'C') {
      return ERROR_BADRESP;
    }
  } else { 
    return ERROR_TIMEDOUT; 
  }
  return 0;
}


// check to see what data is available from the xport
uint8_t AF_XPort::serialavail_timeout(int timeout) {  // in ms
  while (timeout) {
    if (xportserial.available()) {
      if (ctspin) { // we read some stuff, time to stop!
        digitalWrite(ctspin, HIGH);
      }
      return 1;
    }
    // nothing in the queue, tell it to send something
    if (ctspin) {
     digitalWrite(ctspin, LOW);
    }
    timeout -= 1;
    delay(1);
  }
  if (ctspin) { // we may need to process some stuff, so stop now
     digitalWrite(ctspin, HIGH);
  }
  return 0;
}



uint8_t AF_XPort::readline_timeout(char *buff, uint8_t maxlen, int timeout) {
  uint8_t idx;
  char c;

  for (idx=0; idx < maxlen; idx++) {
    buff[idx] = 0;
    if (serialavail_timeout(timeout)) {
      c = xportserial.read();
      //Serial.print(c);    // debugging
      if (c == '\n') {
	return idx;
      } else {
	buff[idx] = c;
      }
    } else {
      // timedout!
      break;
    }
  }
  return idx;
}


// clear out any extra data
void AF_XPort::flush(int timeout) {
  while (serialavail_timeout(timeout)) {
    xportserial.read();
  }
}

// on direct+ and xport's we can toggle a line to disconnect
void AF_XPort::disconnect() {  
  /* digitalWrite(XPORT_DISCONN, LOW);
  delay(20);
  digitalWrite(XPORT_DISCONN, HIGH);*/
}

// print a string from Flash, saves lots of RAM space!
void AF_XPort::ROM_print(const char *pSTR) {
  uint16_t i;  
  for (i = 0; pgm_read_byte(&pSTR[i]); i++) {       
    xportserial.print(pgm_read_byte(&pSTR[i]));  
  } 
}

// all the prints
void AF_XPort::print(uint8_t b) { xportserial.print(b); }
void AF_XPort::print(const char *b) { xportserial.print(b); }
void AF_XPort::print(char b) { xportserial.print(b); }
void AF_XPort::print(unsigned int b) { xportserial.print(b); }
void AF_XPort::print(long b) { xportserial.print(b); }
void AF_XPort::print(long b, int base) { xportserial.print(b, base); }
void AF_XPort::println(void) { xportserial.println(); }
void AF_XPort::println(const char c[]) { xportserial.println(c); }
void AF_XPort::println(uint8_t b) { xportserial.println(b); }
void AF_XPort::println(int b) { xportserial.println(b); }
void AF_XPort::println(long b) { xportserial.println(b); }
void AF_XPort::println(unsigned long b) { xportserial.println(b); }
void AF_XPort::println(long n, int base) { xportserial.println(n, base); }


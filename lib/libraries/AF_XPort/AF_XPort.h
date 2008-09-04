
#ifndef _AFXPort_h_
#define _AFXPort_h_


#define ERROR_NONE 0
#define ERROR_TIMEDOUT 2
#define ERROR_BADRESP 3
#define ERROR_DISCONN 4

#include <avr/pgmspace.h>


class AF_XPort
{
 private:
 
  uint8_t rxpin, txpin, resetpin, dtrpin, rtspin, ctspin;
 public:
  AF_XPort(uint8_t rx, uint8_t tx, uint8_t reset=0, uint8_t dtr=0, uint8_t rts=0, uint8_t cts=0);
  void begin(uint16_t b);
  uint8_t reset(void);
  uint8_t serialavail_timeout(int timeout);
  uint8_t readline_timeout(char *buff, uint8_t maxlen, int timeout);
  void flush(int timeout);
  void disconnect();
  uint8_t connect(char *ipaddr, long port);
  void ROM_print(const char *pSTR);
  uint8_t disconnected();

  void print(char);
    void print(const char[]);
    void print(uint8_t);
    void print(int);
    void print(unsigned int);
    void print(long);
    void print(unsigned long);
    void print(long, int);
    void println(void);
    void println(char);
    void println(const char[]);
    void println(uint8_t);
    void println(int);
    void println(long);
    void println(unsigned long);
    void println(long, int);
};
#endif

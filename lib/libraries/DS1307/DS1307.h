/*
  DS1307.h - library for DS1307 rtc
*/

// ensure this library description is only included once
#ifndef DS1307_h
#define DS1307_h

// include types & constants of Wiring core API
#include <WConstants.h>

// include types & constants of Wire ic2 lib
#include <../Wire/Wire.h>

#define DS1307_SEC 0
#define DS1307_MIN 1
#define DS1307_HR 2
#define DS1307_DOW 3
#define DS1307_DATE 4
#define DS1307_MTH 5
#define DS1307_YR 6
#define DS1307_CTRL	7

#define DS1307_BASE_YR 2000			// with change of get() return from int to byte. this is no longer 
									// used, the user must add 2000 himself

#define DS1307_CTRL_ID B1101000  	// DS1307

 // Define register bit masks  
#define DS1307_CLOCKHALT B10000000
 
#define DS1307_LO_BCD  B00001111
#define DS1307_HI_BCD  B11110000

#define DS1307_HI_SEC  B01110000
#define DS1307_HI_MIN  B01110000
#define DS1307_HI_HR   B00110000
#define DS1307_LO_DOW  B00000111
#define DS1307_HI_DATE B00110000
#define DS1307_HI_MTH  B00110000
#define DS1307_HI_YR   B11110000

// library interface description
class DS1307
{
  // user-accessible "public" interface
  public:
    DS1307();
    void get(byte*, boolean);
    byte get(int, boolean);
	void set(int, int);
    void start(void);
    void stop(void);

  // library-accessible "private" interface
  private:
    byte rtc_bcd[7]; // used prior to read/set ds1307 registers;
	void read(void);
	void save(void);

};

extern DS1307 RTC;

#endif
 

#ifndef SERVO_IS_IN
#define SERVO_IS_IN

#include <inttypes.h>
#include <wiring.h>

class Servo
{
  private:
    uint8_t pin;
    uint8_t angle;       // in degrees
    uint16_t pulse0;     // pulse width in TCNT0 counts
    uint8_t min16;       // minimum pulse, 16uS units  (default is 34)
    uint8_t max16;       // maximum pulse, 16uS units, 0-4ms range (default is 150)
    class Servo *next;
    static Servo* first;
    void write(int);         // specify the angle in degrees, 0 to 180
 public:
    Servo();
    uint8_t attach(int);     // attach to a pin, sets pinMode, returns 0 on failure, won't
                             // position the servo until a subsequent write() happens
    uint8_t attach(int,uint16_t,uint16_t);
                             // same, except min/max pulse is specified
    void detach();
    void position(int);		// enter an angle from 0 to 180
    void speed(int);		// enter a speed from -100 to +100
    uint8_t read();
    uint8_t attached();
    static void refresh();    // must be called at least every 50ms or so to keep servo alive
                              // you can call more often, it won't happen more than once every 20ms
};

#endif

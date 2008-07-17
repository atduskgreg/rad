class BlinkM < ArduinoPlugin

# scaffolding for blink_m
include_wire

add_blink_m_struct

void simply_blink(void)
{
   
}   


static void wire_begin(void) 
{
  delay(200);
	Wire.begin();
}

static void stop_script( void )
{
  Wire.begin();
  Wire.beginTransmission(0x09);
  Wire.send('o');
  Wire.endTransmission();
}

// Call this first (when powering BlinkM from a power supply)

static void BlinkM_begin()
{
    Wire.begin();                // join i2c bus (address optional for master)
}

// General version of BlinkM_beginWithPower().
// Call this first when BlinkM is plugged directly into Arduino

static void BlinkM_beginWithPowerPins(byte pwrpin, byte gndpin)
{
    DDRC |= _BV(pwrpin) | _BV(gndpin);
    PORTC &=~ _BV(gndpin);
    PORTC |=  _BV(pwrpin);
    delay(100);  // wait for things to stabilize

    Wire.begin();
}

// Call this first when BlinkM is plugged directly into Arduino

static void BlinkM_beginWithPower()
{
    BlinkM_beginWithPowerPins( PC3, PC2 );
}

// sends a generic command

static void BlinkM_sendCmd(byte addr, byte* cmd, int cmdlen)
{
    Wire.beginTransmission(addr);
    for( byte i=0; i<cmdlen; i++) 
        Wire.send(cmd[i]);
    Wire.endTransmission();
}

// receives generic data
// returns 0 on success, and -1 if no data available
// note: responsiblity of caller to know how many bytes to expect

static int BlinkM_receiveBytes(byte addr, byte* resp, byte len)
{
    if( Wire.available() ) {
        for( int i=0; i<len; i++) 
            resp[i] = Wire.receive();
        return 0;
    }
    return -1;
}

// Sets the I2C address of the Arduino.  
// Uses "general call" broadcast address

static void BlinkM_setAddress(byte newaddress)
{
  Wire.beginTransmission(0x00);  // general call (broadcast address)
  Wire.send('A');
  Wire.send(newaddress);
  Wire.send(0xD0);
  Wire.send(0x0D);  // dood!
  Wire.send(newaddress);
  Wire.endTransmission();
  delay(30);
}


// Gets the I2C addrss of the Arduino
// Kind of redundant when sent to a specific address
// but uses to verify BlinkM communication

static int BlinkM_getAddress(byte addr)
{
    Wire.beginTransmission(addr);
    Wire.send('a');
    Wire.endTransmission();
    Wire.requestFrom(addr, (byte)1);
    if( Wire.available() ) {
        byte b = Wire.receive();
        return b; 
    }
    return -1;
}

// Gets the BlinkM firmware version

static int BlinkM_getVersion(byte addr)
{
    Wire.beginTransmission(addr);
    Wire.send('Z');
    Wire.endTransmission();
    Wire.requestFrom(addr, (byte)2);
    if( Wire.available() ) {
        byte major_ver = Wire.receive();
        byte minor_ver = Wire.receive();
        return (major_ver<<8) + minor_ver;
    }
    return -1;
}

// Demonstrates how to verify you're talking to a BlinkM 
// and that you know its address

static int BlinkM_checkAddress(byte addr)
{
    //Serial.print("Checking BlinkM address...");
    int b = BlinkM_getAddress(addr);
    if( b==-1 ) {
        //Serial.println("No response, that's not good");
        return -1;  // no response
    } 
    //Serial.print("received addr: 0x");
    //Serial.print(b,HEX);
    if( b != addr )
        return 1; // error, addr mismatch 
    else 
        return 0; // match, everything okay
}

// Sets the speed of fading between colors.  
// Higher numbers means faster fading, 255 == instantaneous fading

static void BlinkM_setFadeSpeed(byte addr, byte fadespeed)
{
    Wire.beginTransmission(addr);
    Wire.send('f');
    Wire.send(fadespeed);
    Wire.endTransmission();  
}

// Sets the light script playback time adjust
// The timeadj argument is signed, and is an additive value to all
// durations in a light script. Set to zero to turn off time adjust.

static void BlinkM_setTimeAdj(byte addr, byte timeadj)
{
    Wire.beginTransmission(addr);
    Wire.send('t');
    Wire.send(timeadj);
    Wire.endTransmission();  
}

// Fades to an RGB color

static void BlinkM_fadeToRGB(byte addr, byte red, byte grn, byte blu)
{
    Wire.beginTransmission(addr);
    Wire.send('c');
    Wire.send(red);
    Wire.send(grn);
    Wire.send(blu);
    Wire.endTransmission();
}

// Fades to an HSB color

static void BlinkM_fadeToHSB(byte addr, byte hue, byte saturation, byte brightness)
{
    Wire.beginTransmission(addr);
    Wire.send('h');
    Wire.send(hue);
    Wire.send(saturation);
    Wire.send(brightness);
    Wire.endTransmission();
}

// Sets an RGB color immediately

static void BlinkM_setRGB(byte addr, byte red, byte grn, byte blu)
{
    Wire.beginTransmission(addr);
    Wire.send('n');
    Wire.send(red);
    Wire.send(grn);
    Wire.send(blu);
    Wire.endTransmission();
}

// Fades to a random RGB color

static void BlinkM_fadeToRandomRGB(byte addr, byte rrnd, byte grnd, byte brnd)
{
    Wire.beginTransmission(addr);
    Wire.send('C');
    Wire.send(rrnd);
    Wire.send(grnd);
    Wire.send(brnd);
    Wire.endTransmission();
}

// Fades to a random HSB color

static void BlinkM_fadeToRandomHSB(byte addr, byte hrnd, byte srnd, byte brnd)
{
    Wire.beginTransmission(addr);
    Wire.send('H');
    Wire.send(hrnd);
    Wire.send(srnd);
    Wire.send(brnd);
    Wire.endTransmission();
}

static void BlinkM_getRGBColor(byte addr, byte* r, byte* g, byte* b)
{
    Wire.beginTransmission(addr);
    Wire.send('g');
    Wire.endTransmission();
    Wire.requestFrom(addr, (byte)3);
    if( Wire.available() ) {
        *r = Wire.receive();
        *g = Wire.receive();
        *b = Wire.receive();
    }
}

static void BlinkM_playScript(byte addr, byte script_id, byte reps, byte pos)
{
    Wire.beginTransmission(addr);
    Wire.send('p');
    Wire.send(script_id);
    Wire.send(reps);
    Wire.send(pos);
    Wire.endTransmission();
}



static void BlinkM_stopScript(byte addr)
{
    Wire.beginTransmission(addr);
    Wire.send('o');
    Wire.endTransmission();
}

static void BlinkM_startScript(byte addr)
{
    Wire.beginTransmission(addr);
    Wire.send('p');
    Wire.endTransmission();
}



static void BlinkM_setScriptLengthReps(byte addr, byte script_id, 
                                       byte len, byte reps)
{
    Wire.beginTransmission(addr);
    Wire.send('L');
    Wire.send(script_id);
    Wire.send(len);
    Wire.send(reps);
    Wire.endTransmission();
}

static void BlinkM_writeScriptLine(byte addr, byte script_id, 
                                   byte pos, byte dur,
                                   byte cmd, byte arg1, byte arg2, byte arg3)
{
    Serial.print("\nwriting line:");  Serial.print(pos,DEC);
    Serial.print(" with cmd:"); Serial.print(cmd); 
    Serial.print(" arg1:"); Serial.println(arg1,HEX);
    
    Wire.beginTransmission(addr);
    Wire.send('W');
    Wire.send(script_id);
    Wire.send(pos);
    Wire.send(dur);
    Wire.send(cmd);
    Wire.send(arg1);
    Wire.send(arg2);
    Wire.send(arg3);
    Wire.endTransmission();
}

static void BlinkM_writeScript(byte addr, byte script_id, 
                               byte len, byte reps,
                               blinkm_script_line* lines)
{
    for(byte i=0; i < len; i++) {
        blinkm_script_line l = lines[i];
        BlinkM_writeScriptLine( addr, script_id, i, l.dur,
                                l.cmd[0], l.cmd[1], l.cmd[2], l.cmd[3]);
    }
    BlinkM_setScriptLengthReps(addr, script_id, len, reps);
}










end
class BlinkM < ArduinoPlugin

# scaffolding for blink_m

include_wire




void simply_blink(void)
{
   
}   


static void clear_blinkm( void )
{
  Wire.beginTransmission(0x09);
  Wire.send('c');
  Wire.endTransmission();
}



end
class Midi < ArduinoPlugin
 
 
# reference 
  
# To send MIDI, attach a MIDI out jack (female DIN-5) to Arduino.
# DIN-5 pinout is:                               _____ 
#    pin 2 - Gnd                                /     \
#    pin 4 - 220 ohm resistor to +5V           | 3   1 |  Female MIDI jack 
#    pin 5 - Arduino D1 (TX)                   |  5 4  |
#    all other pins - unconnected               \__2__/
#  Adapted from Tom Igoe's work at:
#   http://itp.nyu.edu/physcomp/Labs/MIDIOutput
#  And Tod E. Kurt <tod@todbot.com
#   http://todbot.com/
#
#  Created 25 October 2008
#  copyleft 2008 jdbarnhart 
#  http://jdbarnhart.com/
  
void note_on(char cmd, int data1, char data2) {
  Serial.print(cmd, BYTE);
  Serial.print(data1, BYTE);
  Serial.print(data2, BYTE);
}
  
void note_on(int channel, int note, int velocity) {
  midi_msg( (0x90 | (channel)), note, velocity);
}

void note_on(long int& channel, long int& note, long int& velocity) {
  midi_msg( (0x90 | (channel)), note, velocity);
}

void note_off(long int& channel, long int& note, long int& velocity) {
  midi_msg( (0x90 | (channel)), note, velocity);
}

void note_off(byte channel, byte note, byte velocity) {
  midi_msg( (0x90 | (channel)), note, velocity);
}

void play_note(long int& channel, long int& note, long int& velocity) {
  midi_msg( (0x90 | (channel)), note, velocity);
  delay(100);
  midi_msg( (0x90 | (channel)), note, 0);
}



void midi_msg(byte cmd, byte data1, byte data2) {
  digitalWrite(led(), 1); // indicate we're sending MIDI data
  Serial.print(cmd, BYTE);
  Serial.print(data1, BYTE);
  Serial.print(data2, BYTE);
  digitalWrite(led(), 0); // indicate we're sending MIDI data
}


end
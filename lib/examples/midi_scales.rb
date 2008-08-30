class MidiScales < ArduinoSketch
  
# purpose
# trigger midi output with buttons and
# spectra soft pots
#
#


  @current_note = int
  @last_note_one = 0
  @last_note_two = 0
  @last_note_three = 0
  @note = int

  input_pin 1, :as => :sensor_one, :device => :spectra
  input_pin 2, :as => :sensor_two, :device => :spectra
  input_pin 3, :as => :sensor_three, :device => :spectra
  input_pin 7, :as => :button_one, :device => :button
  input_pin 8, :as => :button_two, :device => :button
  input_pin 9, :as => :button_three, :device => :button
  output_pin 13, :as => :led

  serial_begin :rate => 31250

  def setup
    delay 3000
  end

  def loop
    change_tone if button_one.read_input
    change_pressure if button_two.read_input
    change_channels if button_three.read_input
    read_sensor_one
    read_sensor_two
    read_sensor_three
  end
     
  def change_tone 
    110.upto(127) do |note|
      play 0, note, 127
    end
  end

  def change_pressure
    110.upto(127) do |pressure| 
       play 0, 45, pressure
    end
  end
     
  def change_channels 
    0.upto(6) do |channel| 
      play channel, 50, 100
    end
  end

  def read_sensor_one
    @current_note = sensor_one.soft_lock
    pre_play(@current_note, @last_note_one, 13)
    @last_note_one = @current_note
  end

  def read_sensor_two
    @current_note = sensor_two.soft_lock
    pre_play(@current_note, @last_note_two, 14)
    @last_note_two = @current_note
  end

  def read_sensor_three
    @current_note = sensor_three.soft_lock
    pre_play(@current_note, @last_note_three, 15)
    @last_note_three = @current_note
  end

  def pre_play(current_note, last_note, channel) # warning, don't use last as a parameter...
    n = 1 + channel
    unless current_note == last_note
      @note = ((current_note /16) + 40)
      play_with_no_delay( channel, @note, 100 )
    end
  end
    
  def play(chan, note, pressure)
    note_on(chan, note, pressure)
    delay 100 # adjust to need
    note_off(chan, note, 0)
  end
  
  def play_with_no_delay(chan, note, pressure) # note is not turned off
    note_on(chan, note, pressure)
  end


end

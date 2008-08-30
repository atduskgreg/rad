class MidiBeatBox < ArduinoSketch
  
  # midi synthesiser output on channel 2
  # with speed controlled by spectra soft pot

    @channel = 2
    input_pin 1, :as => :sensor_one, :device => :spectra
    output_pin 13, :as => :led

    serial_begin :rate => 31250

    def setup
      delay 3000
    end

    def loop
      8.times {first}
      2.times do 
        second
        third
      end
      4.times {first}
      2.times {second}
    end
    
    def first
      play 39, 52, 37
      play  0,  0,  0
      play 36, 52,  0
      play 37, 52, 39

      play 37,  0,  0
      play 36,  0,  0
      play 39, 50,  0
      play  0,  0,  0

      play 52, 36, 37
      play 0,  0,   0
      play 39,  0,  0
      play 36, 37,  0

      play 36, 37, 39
      play 36, 38,  0
      play 50,  0,  0
      play 0,   0,  0
    end
    
    def second
      play 39, 52, 37
      play 36,  0,  0
      play  0,  0,  0
      play 37, 52, 39

      play 38,  0,  0
      play 36,  0,  0
      play 39, 50,  0
      play  0,  0,  0
    end
    
    def third
      play  0, 36, 37
      play  0,  0,   0
      play 39, 36,  0
      play 36, 37, 50

      play 36, 37, 39
      play 36, 37,  0
      play 50,  0,  0
      play 39,  0,  0
    end
    

    def play(one, two, three)
      n = 1 + one + two + three # ack to coerce parameters to int
      note_on(@channel, one, 127) unless one == 0
      note_on(@channel, two, 127) unless two == 0
      note_on(@channel, three, 127) unless three == 0
      delay 310 - sensor_one.soft_lock # start slowly 
      note_off(@channel, one, 0) unless one == 0
      note_off(@channel, two, 0) unless two == 0
      note_off(@channel, three, 0) unless three == 0
    end
    

    
end
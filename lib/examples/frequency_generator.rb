class FrequencyGenerator < ArduinoSketch
  
  # need explaination
  
  output_pin 11, :as => :myTone, :device => :freq_out, :frequency => 100

     def loop
         uh_oh 4   
     end

     def uh_oh(n)
       

         n.times do
             myTone.enable
             myTone.set_frequency 1800
             delay 500
             myTone.disable
             delay 100
             myTone.enable
             myTone.set_frequency 1800
             delay 800
             myTone.enable
         end
         # hack to help translator guess that n is an int
         f = n + 0
      end
      

end

class Twitter < ArduinoSketch
  
  #include <avr/io.h>
  #include <string.h>



  define "TWEETLEN 141"
  define "HOSTNAME www.twitter.com"
  
  define 'IPADDR "128.121.146.100"'  # twitter.com
  define "PORT 80"                 # // HTTP
  define "HTTPPATH /atduskgreg/"    # // the person we want to follow
  

  define "TWEETLEN 141"
  array "char linebuffer[256]" # // our large buffer for data
  array "char tweet[TWEETLEN]" # // the tweet
  @lines = 0

  
  define "XPORT_RXPIN 2"
  define "XPORT_TXPIN 3"
  define "XPORT_RESETPIN 4"
  define "XPORT_DTRPIN 5"
  define "XPORT_CTSPIN 6"
  define "XPORT_RTSPIN 7"
  

  @errno = 0
  @laststatus = 0
  @currstatus = 0


  
# in setup
#xport = AF_XPort(XPORT_RX, XPORT_TX, XPORT_RESET, XPORT_DTR, XPORT_RTS, XPORT_CTS)
  
  
  output_pin 10, :as => :shield, :device => :ethernet
  
  serial_begin :rate => 57600
  
  def loop
    
#  local_connect()
    # kind of a problem... fixed
    get_tweet
    fetchtweet
    delay 30000


  end
  

  
end
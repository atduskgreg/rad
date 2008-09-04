class TwitterConnect < ArduinoPlugin




void get_tweet() {
  // hack to pull 
}

uint32_t parsenumber(char *str) {
  uint32_t num = 0;
  char c;
  
  // grabs a number out of a string
  while (c = str[0]) {
   if ((c < '0') || (c > '9'))
     return num;
   num *= 10;
   num += c - '0';
   str++;
 }
 return num;
}


char * fetchtweet(void) {
  Serial.print("... fetching tweets....");
  uint8_t ret;
  char *found=0, *start=0, *end=0;
  
  tweet[0] = 0;  // reset the tweet
  ret = xport.reset();
  //Serial.print("Ret: "); Serial.print(ret, HEX);
  switch (ret) {
   case  ERROR_TIMEDOUT: { 
      Serial.println("Timed out on reset!"); 
      return 0;
   }
   case ERROR_BADRESP:  { 
      Serial.println("Bad response on reset!");
      return 0;
   }
   case ERROR_NONE: { 
    Serial.println("Reset OK!");
    break;
   }
   default:
     Serial.println("Unknown error"); 
     return 0;
  }
  
  // time to connect...
 
  ret = xport.connect(IPADDR, PORT);
    switch (ret) {
   case  ERROR_TIMEDOUT: { 
      Serial.println("Timed out on connect"); 
      return 0;
   }
   case ERROR_BADRESP:  { 
      Serial.println("Failed to connect");
      return 0;
   }
   case ERROR_NONE: { 
     Serial.println("Connected..."); break;
   }
   default:
     Serial.println("Unknown error"); 
     return 0;
  }
  
  // send the HTTP command, ie "GET /username/"
  
    xport.print("GET "); xport.println(HTTPPATH);
// the following works with instiki, but not on twitter...
//  xport.print("GET "); 
//  xport.print(HTTPPATH);
//  xport.println(" HTTP/1.1");
//  xport.print("Host: "); xport.println(HOSTNAME);
//  xport.println("");
    
  

  while (1) {
    // read one line from the xport at a time
    ret = xport.readline_timeout(linebuffer, 255, 4000); // 3s timeout
    // if we're using flow control, we can actually dump the line at the same time!
    // Serial.print(linebuffer);
    
    // look for an entry (the first one)
    found = strstr(linebuffer, "entry-title entry-content");
    if (((int)found) != 0) {
      start = strstr(found, ">") + 1;
      end = strstr(found, "</p>");
      if ((start != 0) && (end != 0)) {
        Serial.println("\n******Found first entry!*******");
        end[0] = 0;
        Serial.print(start);
        // save the tweet so we can display it later
        strncpy(tweet, start, TWEETLEN);
        tweet[TWEETLEN-1] = 0;
      }
    }
    
    // next we look for a status ID (which should correspond to the previous tweet)e
    // Serial.print(".");
    // Serial.print(linebuffer);
    found = strstr(linebuffer, "<div id=\"status_actions_");  
    if (((int)found) != 0) {
      start =  found + 25; // strlen("<span id=\"status_actions_")
      end = strstr(found, "\">");
      if ((start != 0) && (end != 0)) {
        Serial.println("\n******Found status ID!*******");
        end[0] = 0;
        Serial.println(start);
        // turn the string into a number
        __currstatus = parsenumber(start);
        Serial.println(__currstatus, DEC);
        
        // check if this is a nu tweet
        if (__currstatus > __laststatus) {
           __laststatus = __currstatus;
           Serial.println("New message");
           Serial.print(tweet);
        } else {
          tweet[0] = 0;
        }
       // flush the conn
       xport.flush(5000); // 5 second timeout
 
       if (tweet[0] == 0) { return 0; }
       else {return tweet; }
      }
    }
    
    if (((__errno == ERROR_TIMEDOUT) && xport.disconnected()) ||
        ((XPORT_DTRPIN == 0) &&
         (linebuffer[0] == 'D') && (linebuffer[1] == 0)))  {
       Serial.println("\nDisconnected...");
       return 0;
    }
  }
}

end

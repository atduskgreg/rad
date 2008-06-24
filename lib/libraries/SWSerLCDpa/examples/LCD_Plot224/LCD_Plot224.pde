// LCD_PLOT - Arduino
//
// Tx ---------------------------- To mySerial LCD (LCD #117)
//
// Peter H Anderson, Baltimore, MD, May 10, '07

#include <SWSerLCDpa.h>

#define    txPin   14
#define    LEDpin  13
#define    DISPGEO 224
#define    DCOLs   24    // # of Display COLumns
#define    DROWs    2    // # of Display ROWs
#define    NUMDATs 42
 
  // create a new instance of a software mySerial port
  SWSerLCDpa mySerial =  SWSerLCDpa(txPin);

void setup()
{

  pinMode(txPin, OUTPUT);       // define pin modes for tx pin

  mySerial.begin(9600);
  delay(50);
  mySerial.clearscr();
  mySerial.setgeo(DISPGEO);

  mySerial.print("?D00000000000000000");		// define special characters
  delay(200);   // delay to allow write to EEPROM
  mySerial.print("?D1000000000000001f");
  delay(200);
  mySerial.print("?D20000000000001f1f");
  delay(200);
  mySerial.print("?D300000000001f1f1f");
  delay(200);
  mySerial.print("?D4000000001f1f1f1f");
  delay(200);
  mySerial.print("?D50000001f1f1f1f1f");
  delay(200);
  mySerial.print("?D600001f1f1f1f1f1f");
  delay(200);
  mySerial.print("?D7001f1f1f1f1f1f1f");
  delay(200);
}

void loop()
{
   int i, display_array[DCOLs], temperature, scale32;

   mySerial.clearscr();
   delay(100);

   for (i=0; i<NUMDATs; i++)
   {
      scale32= meas_temp(i);
      add_to_array(display_array, scale32, i);
      plot_array(display_array, (i<DCOLs ? i : DCOLs));
      delay(100); // **************** Adjust as required
   }
   while (1)
   {
    delay(1);
   }
   
  // delay (5000);
}

void plot_array(int a[], int num_cols)
{
  int n;
  for (n=0; n<num_cols; n++)
  {
     plot_bar(a[n], n);
  }
}

void add_to_array(int a[], int v, int num_dats)
{

   int n, index;

   index = num_dats;
   if (index < DCOLs)
   {
       a[index] = v;
       ++index;
   }
   else
   {
       for (n=0; n<(DCOLs-1); n++)
       {
          a[n] = a[n+1];  // move to the left
       }
       a[DCOLs-1] = v; // put the new element on the end
   }
}

int meas_temp(int n)
{
  /* 
      this is a stub which simulates a temperature reading. I replaced the 
      values with already scaled numbers base on 0-13 (2 lines) and use a 2x
      multiplier for 4 lines
  */
    const int temp_readings[NUMDATs] = { 1, 2, 3, 4, 5, 6, 7,
                                         8, 9, 10, 11, 12, 13, 10,
                                         7, 4, 0, 1, 2, 3, 4,
                                         1, 2, 3, 4, 5, 6, 7,
                                         8, 9, 10, 11, 12, 13, 10,
                                         7, 4, 0, 1, 2, 3, 4};
    if (DROWs > 2) 
    {
        return(2 * temp_readings[n]);
    }
    else
    {                    
        return(temp_readings[n]);
    }
}


void plot_bar(int hght, int col)
{
   int n, row;

   for (n=0; n < DROWs;  n++)    //  <4
   {
       row = (DROWs-1) - n;  // 3-n
       mySerial.print("?x");
      if(col < 10)
       {
          mySerial.print("0"); // be sure it is two characters
      }
       mySerial.print(col);

       mySerial.print("?y");
       mySerial.print(row);

       if (hght >=7)
       {
           mySerial.print("?7"); // lay down a full block
           hght = hght - 7;
       }
       else
       {
           mySerial.print("?");
           mySerial.print(hght);
           hght = 0;
       }
       delay(5);
   }
}

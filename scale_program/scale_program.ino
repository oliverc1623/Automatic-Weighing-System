#include <HX711.h> // include Hx711 package to call functions on the load cell

HX711 scale(3,2); // use digital pors 3 & 2;
                  // use digital ports 30 & 20 if using arduini mini
                  
byte tmp; // placholder variable we use to check

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);

   // put your setup code here, to run once:
  Serial.begin(9600);  

  /* These are the default calibration factor for each type of load cell
     However, EVERY load cell will hace a DIFFERENT calibration factor
     These are just rough estimates for each type of load cell 
  */ 
  float fiveKgCf = -38650; //calibration factor for 5kg load cell old: 45350
  float oneKgCF = -84450; //calibration factor for 1kg load cell
  float twentyKgCF = -128850; // 66650

  float calibrationFactor;

  // Default calibration factor is the 5 kg value
  scale.set_scale(fiveKgCf);  

  // tare the scale at the start
  scale.tare();
}

void loop() {

  // check for uncoming bytes sent from the matlab program
  if(Serial.available())
  {
    // set the temp equal to the matlab value we sent e.g. 'r', 't'...
    char temp = Serial.read();
    if(temp == 't' || temp == 'T')
      scale.tare();  //Reset the scale to zero
      
    // Have the arduino send the weight to matlab program  
    if(temp == 'r' || temp == 'R') 
        /* 
         * print weight in kg to units
         * the second argument in println is the amount of decimal places to return 
         */
        Serial.println(scale.get_units(), 4); 
    if(temp == 's'){
        // read the new cf value matlab wrote to arduino
        String cfString = Serial.readString();
        // convert string to float value
        float newCF = cfString.toFloat();
        // call the set_cale method to change the calibration factor
        scale.set_scale(newCF);  
    }
  }
}


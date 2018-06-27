#include <HX711.h>

HX711 scale(3,2);

byte tmp;
float x;
float test = 2.322;

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);

    // put your setup code here, to run once:
  Serial.begin(9600);  
  //Serial.println("Press T/t to tare");
  
  float fiveKgCf = -382760; //calibration factor for 5kg load cell old: 45350
  float oneKgCF = -84450; //calibration factor for 1kg load cell
  float twentyKgCF = -128850; // 66650

  float calibrationFactor;
  
  scale.set_scale(oneKgCF);  //Calibration Factor obtained from first sketch
  scale.tare();   
}

void loop() {
  // put your main code here, to run repeatedly:
  //Serial.print("Weight: ");
  //Serial.println(scale.get_units());  //Up to 3 decimal points
  //Serial.println(" kg"); //Change this to kg and re-adjust the calibration factor if you follow lbs
  
  float f;

  float fiveKgCf = -39000; //calibration factor for 5kg load cell
  float oneKgCF = -84450; //calibration factor for 1kg load cell
  float twentyKgCF = -66650; // 66650

  if(Serial.available())
  {
    char temp = Serial.read();
    if(temp == 't' || temp == 'T')
      scale.tare();  //Reset the scale to zero  
    if(temp == 'r' || temp == 'R')
     
        //Serial.write(45);
        Serial.println(scale.get_units());
        // Serial.println(scale.get_units());

    if(temp == 's' || temp == 'S')
        // Set the scaling factor for 1kg
        scale.set_scale(oneKgCF);
    if(temp == 'g' || temp == 'G')
        // Set the scaling factor for 5kg
        scale.set_scale(fiveKgCf);
    if(temp == 'k' || temp == 'K')
        // Set the scaling factor for 20kg
        scale.set_scale(twentyKgCF);
        
    }
}
//        char *c_Data = ( char* ) &f;
//        Serial.println(sizeof(float));
//        for( char c_Index = 0 ; c_Index < sizeof( float ) ; Serial.write( c_Data[ c_Index++ ] ) );
      

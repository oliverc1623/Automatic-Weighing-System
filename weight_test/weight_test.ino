#include <HX711.h>

HX711 scale(3,2);

byte tmp;
float x;

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);

    // put your setup code here, to run once:
  Serial.begin(9600);  
  //Serial.println("Press T/t to tare");
  
  float fiveKgCf = -36850; //calibration factor for 5kg load cell
  float oneKgCF = -85000; //calibration factor for 1kg load cell
  float twentyKgCF = -66650;
  
  scale.set_scale(oneKgCF);  //Calibration Factor obtained from first sketch
  scale.tare();   
}

void loop() {
  // put your main code here, to run repeatedly:
  //Serial.print("Weight: ");
  //Serial.println(scale.get_units());  //Up to 3 decimal points
  //Serial.println(" kg"); //Change this to kg and re-adjust the calibration factor if you follow lbs
//  
  float f;
//
  if(Serial.available())
  {
    char temp = Serial.read();
    if(temp == 't' || temp == 'T')
      scale.tare();  //Reset the scale to zero  
    if(temp == 'r' || temp == 'R')
     
        //Serial.write(45);
        f = scale.get_units();
        char *c_Data = ( char* ) &f;
        Serial.println(sizeof(float));
        for( char c_Index = 0 ; c_Index < sizeof( float ) ; Serial.write( c_Data[ c_Index++ ] ) );
      }
      
//      f = scale.get_units();
//
//      //Serialise data.
//      char *c_Data = ( char* ) &f;
//      for( char c_Index = 0 ; c_Index < sizeof( float ) ; Serial.write( c_Data[ c_Index++ ] ) );

        //Serial.write(1);
        //Serial.println("read from arduino");
//  }
}

typedef union {
 float floatingPoint;
 byte binary[4];
} binaryFloat;


void serialEvent(){
    while(Serial.available()){
        tmp = Serial.read();
        switch(tmp){
            case 0x01: //tare the scale
            {
                binaryFloat bFloat;
                
                bFloat.floatingPoint = scale.get_units();
                
                Serial.write(bFloat.binary, 4);
                
                break;
            }
            case 0x02: // read the load cell
                float Kg = (scale.get_units(), 3);
                
                digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
                delay(1000);                       // wait for a second
                digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
                delay(1000); 
                
                Serial.write(0x02);
                
                break;
        }
    }
}


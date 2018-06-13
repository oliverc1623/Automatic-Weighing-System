#include <HX711.h>

HX711 scale(3,2);

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);  
  Serial.println("Press T/t to tare");
  
  float fiveKgCf = -36650; //calibration factor for 5kg load cell
  float oneKgCF = -85000; //calibration factor for 1kg load cell
  
  scale.set_scale(oneKgCF);  //Calibration Factor obtained from first sketch
  scale.tare();   
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.print("Weight: ");
  Serial.print(scale.get_units(), 3);  //Up to 3 decimal points
  //Serial.print((scale.read_average(0)-scale.get_offset())/-85000,3);
  Serial.println(" kg"); //Change this to kg and re-adjust the calibration factor if you follow lbs
  
  if(Serial.available())
  {
    char temp = Serial.read();
    if(temp == 't' || temp == 'T')
      scale.tare();  //Reset the scale to zero      
  }
}


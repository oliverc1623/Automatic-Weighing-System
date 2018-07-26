# Automatic-Weighing-System

This program, written in MATLAB measures the weight of a lab animal. The program reads the weight in Kg the load cell detects. Additionally, the load cell, Hx711 chip, and arduino are hooked up inside a box such that to 5 Kg load cells acts as one 10 Kg load cell to measure the weight of an animal in a behavior box.

# Table of Contents  
=================
* [Getting Started](#getting-started)  
  * [Hardware Prerequisites](#hardware-prerequisites)  
  * [Software Prerequisites](#software-prerequisites)
* [Load cell to Arduino hookup guide](#load-cell-to-arduino-hookup-guide)
* [Installation](#installation)
* [Arduino code](#arduino-code)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Hardware Prerequisites

- Two 5 Kg load cells
- Two Hx711 chips
- Two arduino minis
- Two USB wires
- Acrylic box
- female-to-female jumper wire

### Software Prerequisites

Install the Hx711 library so that the arduino can get data from the load cell. https://halckemy.s3.amazonaws.com/uploads/attachments/392655/HX711-master.zip

If you are using an Arduino Mini install the latest board, Atmel AVR Xplained-minis from the arduino board manager, and select Atmel amtmega328pb Xplained mini board. 

## Load cell to Arduino hookup guide

1. Cut the load cell wires and female-to-female jumper wire to shorten them.
2. Solder the load cell wires to the female-to-female jumper wire
  ex: ![load cell wires soldered to female-to-female jumper wire](https://github.com/oliverc1623/Automatic-Weighing-System/blob/master/load_cell_solder_wire.jpg)
  
3.Solder pins to Hx711 chip (pins should come in bag)

4. Connect the jumper wire to the Hx711 chip in the following order:

- Red wire to E+
- Black wire to E-
- Green wire to A-
-White wire to A+

5. Get new jumper wire to connect Hx711 chip to arduino
 Add these wires to Hx711 chip: 
 
- Black wire to GND
- Black wire to DT
- Purle wire to SCK
- Red wire to VOC

![load cell wires on Hx711 chip](https://github.com/oliverc1623/Automatic-Weighing-System/blob/master/hx711_closeup.jpg)

6. Connect the Hx711 wires to Arduino

- Black wire to GND
- Red wire to 5V
- Blue wire to Digital 3(30)
- Purple wire to Digital 2(20)

![hx711 wires to arduino](https://github.com/oliverc1623/Automatic-Weighing-System/blob/master/arduino_closeup.jpg)

## Installation

Download the zip package of this github repository and run the matlab program `scale_gui3.m` in the matlab command window if you wish to run more than 2 load cells, or run `behavior_box.m` in the matlab command window in to measure the weight of an animal inside the behvaior box.

Be sure to upload the `scale_program.ino` code to your arduino to return the weight. 

Also, if you want to know the calibration factor for a specific load cell you can also upload the program, `scale_calibration.ino`, and open the serial monitor to edit the calibration factor such that the load cell returns the correct weight of a given object.

### Arduino code

There are two arduino programs in this project. `scale_calibration.ino` allows the user to quickly change the calibration factor so that the load cell will read the correct weight through the serial monitor in the arduino ide. The second program, `scale_program.ino` prints the weight value (in Kg) to the Serial, at which the matlab program scans and plots it.

It is recommended to use an Arduino mini (or similar circuit board) to fit everything in a 1.5"x17"x12" box. 

### 

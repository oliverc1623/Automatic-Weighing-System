# Automatic-Weighing-System

This program, written in MATLAB measures the weight of a lab animal. The program reads the weight in Kg the load cell detects. Additionally, the load cell, Hx711 chip, and arduino are hooked up inside a box such that to 5 Kg load cells acts as one 10 Kg load cell to measure the weight of an animal in a behavior box.

# Table of Contents  
=================
* [Getting Started](#getting-started)  
  * [Hardware Prerequisites](#hardware-prerequisites)  
  * [Making the scale box](#making-the-scale-box)
  * [Software Prerequisites](#software-prerequisites)
* [Load cell to Arduino hookup guide](#load-cell-to-arduino-hookup-guide)
* [Installation](#installation)
* [Arduino code](#arduino-code)
* [Matlab code](#matlab-code)
  * [System_scale](#system-scale)
  * [Run scale](#run-scale)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Hardware Prerequisites

- Two 5 Kg load cells
- Two Hx711 chips
- Two arduino minis
- Two USB wires
- Acrylic box
- female-to-female jumper wire

##    Making the scale box

The first priority in making a scale box is to have a gap between the load cell and surface on which the object lays upon.

For our box we decided to lazer cut 1/4" cast acrylic. The box designs were made with makercase.com and adobe illustrator(for fine adjustments); the sheet in illustrator should match the dimensions of the acrylic sheet you are printing on. 

Files for acryilic cut outs will be attached. 

When assembling the box, be sure to use 4mm screws for the top and 5mm screws for the bottom holes. Additionally, there should be even spacing pressing against both sides of the load cell to balance it. It's recommended to use  5-6mm plastic spacers to separate the top sheet from the box. 

Checkout the illustrator file to see how we designed the box. 

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

### Matlab code

In the malab code folder you will see three matlab programs. `weight_sensor.m` is the object class for the weight sensor; a weight sensor object made from this class can call methods such as `x.readWeight()`.

`scale_gui3.m` comes with a gui and theoretically runs for ever until the file it writes to fill the pc's hard drive. This program streamlines the plotting and writing process of each sensor, or in other words, loops through all the active sensors so that the gui plots the weight or write to a txt file. 

`behavior_box.m`takes the average of two 5 Kg load cells. This program is intended to hold the measure the weight of an animal inside the behavior box as it tests. The functionality of the program is nearly the same as `scale_gui3.m`, however, we only activate two sensors and take the average weight in Kg. 

#### System scale

System scale is a class in the organizes which sensors to read or write. It also couples the sensors together so that 2 sensors correspond with their respective box. System_scale is also where the sensor objects are instantiated. 

#### Run scale

Run_scale is a program that will run a continuous loop. During this loop the program will plot the weight from each box. Run scale is tied with the program's GUI such that all the logical components of every gui piece is handled here. 

#### Scale sensor

Scale_sensor class holds the variables and methods to create a sensor object. The other classes utilize a sensor object to retrieve the sensors data, tare, or set the calibration factor. The constructor accepts one argument that is the com port
e.g.  `scale_sensor('COM12')`

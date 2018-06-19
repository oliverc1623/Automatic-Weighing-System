%pylab

#%%
import serial
import matplotlib
import matplotlib.pyplot as plt
import time
import numpy as np
ser = serial.Serial('COM3', 9600)

#%%

def tareScale(): #tells arduino to tare the scale
    ser.write(b'1')    

#%%
    
def readScale():
    ser.write(b'r')
    line = float(ser.readline())
    print(line)
    ser.flush()
    return line
    
#%%
    
for i in range(1,100):
    readScale()

#%%

data = []

for i in range(1,100):
    data.append(readScale())
    
    plt.plot(range(i), data, 'b')
    plt.ylabel('Weight in Kg')
    plt.show()
    plt.pause(0.25)
    
#plt.ylabel('Weight in Kg')
#plt.show()

#%%

# plt.plot([1, 2, 3, 4])
# plt.ylabel('some numbers')
# plt.show()
data = []

data = np.zeros(100);   

# start = raw_input("Press t to tare: ")
# characterList = start
# ser.write(characterList[0])

nSamples = 100;

#data = np.zeros(nSamples);

for i in range(nSamples):
    #time.sleep(0.02)
    #print (float(ser.readline()))
    data[i] = float(readScale())
        
    #i_plot = np.mod(i, 100)+1; # Reset every 1000 points
    #if i_plot == 1:
    #    plt.cla() # Clear the plot
    
    
    plt.plot(range(i), data, 'k')
    #plt.ylabel('Weight in Kg')
    #plt.show()
    plt.pause(0.5)
    

#print(data)

#plt.plot(data)
plt.ylabel('Weight in Kg')
plt.show()
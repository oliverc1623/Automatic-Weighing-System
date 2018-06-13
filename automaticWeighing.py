#%pylab
import serial
import matplotlib
import matplotlib.pyplot as plt
import time
import numpy as np



ser = serial.Serial('/dev/ttyACM0', 9600)

# plt.plot([1, 2, 3, 4])
# plt.ylabel('some numbers')
# plt.show()
timeEnd = time.time() + 10
plt.ion()
data = []

# start = raw_input("Press t to tare: ")
# characterList = start
# ser.write(characterList[0])
data = np.zeros(100);

for i in range(100):
	time.sleep(0.05) 
	data[i] = float(ser.readline())
	plt.plot(range(i), data[:i])
	plt.ylabel('Weight in Kg')
	#plt.show()
#	if time.time() > timeEnd:
#		break


print(data)

plt.plot(data)
plt.ylabel('Weight in Kg')
plt.show()
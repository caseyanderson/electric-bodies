#receive from arduino via pyserial
import OSC
import time, random
import serial
m = []

client = OSC.OSCClient()
client.connect( ( '127.0.0.1', 57120 ) )
msg1 = OSC.OSCMessage()
msg2 = OSC.OSCMessage()
msg3 = OSC.OSCMessage()

msg1.setAddress('/m1')
msg2.setAddress('/m2')
msg3.setAddress('/m3')

msg1.append(0)
msg2.append(0)
msg3.append(0)

ser = serial.Serial('/dev/tty.usbmodem1411', 9600)

while True:
	try:
		m = ser.readline().split('_')
		#print m
		msg1[0] = m[0]
		client.send(msg1)
		msg2[0] = m[1]
		client.send(msg2)
		n = m[2].replace('\r\n', '')
		msg3[0] = n
		client.send(msg3)
	except KeyboardInterrupt:
		break

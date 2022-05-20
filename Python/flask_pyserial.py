from asyncio.windows_events import NULL
import gpiozero as gz
from flask import Flask
import serial
import time

app = Flask(__name__)

# serX = serial.Serial("COM5", baudrate = 9600, timeout=10)
# serO = serial.Serial("COM4", baudrate = 9600, timeout=10)

serX = NULL
serO = NULL

posX = 5
posO = 175

servo = gz.AngularServo(17, min_angle=0, max_angle=180)

print("Connected")

# serX.reset_input_buffer()
# serO.reset_input_buffer()

def wait_for_reply_X():
    while(serX.in_waiting == 0):
        time.sleep(0.1)
    received = serX.readline()
    print("X Received --> " + received.decode())
    return received.decode()

def wait_for_reply_O():
    while(serO.in_waiting == 0):
        time.sleep(0.1)
    received = serO.readline() 
    print("O Received --> " + received.decode())
    return received.decode()

@app.route('/api/move/<player>/<spot>')
def api_move():
    serX.reset_input_buffer() # Just in case
    serO.reset_input_buffer() # Just in case
    command = f'{spot}\n'
    print("Sent -->", command)
    if {player} == "X":
        servo.angle = posX
        time.sleep(0.2)
        serX.write(command.encode())
        return wait_for_reply_X()
    else:
        servo.angle = posO
        time.sleep(0.2)
        serO.write(command.encode())
        return wait_for_reply_O()

@app.route('/api/connect/<player>/<port>')
def api_connect():
    if {player} == "X":
        message = "Closing X port"
        serX.write(message.encode())
        serX.close()
        serX = serial.Serial({port}, baudrate=9600, timeout=10)
        serX.reset_input_buffer()
        message = "Port {port} is now open"
        serX.write(message.encode())
        return wait_for_reply_X()
    else:
        message = "Closing O port"
        serO.write(message.encode())
        serO.close()
        serO = serial.Serial({port}, baudrate = 9600, timeout=10)
        serO.reset_input_buffer()
        message = "Port {port} is now open"
        serO.write(message.encode())
        return wait_for_reply_O()




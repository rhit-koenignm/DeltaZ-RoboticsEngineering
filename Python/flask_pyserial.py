from asyncio.windows_events import NULL
from winsound import PlaySound
from flask import Flask
import serial
import time

app = Flask(__name__)

# serX = serial.Serial("COM5", baudrate = 9600, timeout=10)
# serO = serial.Serial("COM4", baudrate = 9600, timeout=10)

serX = NULL
serO = NULL

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
        serX.write(command.encode())
        return wait_for_reply_X()
    else:
        serO.write(command.encode())
        return wait_for_reply_O()

@app.route('/api/connect/<player>/<port>')
def api_connect():
    if {player} == "X":
        message = "Closing X port"
        serX.write(message.encode())
        serX.close()
        serX = serial.Serial({port}, baudrate = 9600, timeout=10)
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
    
    
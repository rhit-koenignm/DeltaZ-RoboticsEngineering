from curses import baudrate
from winsound import PlaySound
from flask import Flask
import serial
import time

app = Flask(__name__)

serX = serial.Serial("COM5", baudrate = 9600, timeout=10)
serY = serial.Serial("COM4", baudrate = 9600, timeout=10)

print("Connected")

serX.reset_input_buffer()
serY.reset_input_buffer()

def wait_for_reply_X():
    while(serX.in_waiting == 0):
        time.sleep(0.1)
    received = serX.readline()
    print("X Received --> " + received.decode())
    return received.decode()

def wait_for_reply_Y():
    while(serY.in_waiting == 0):
        time.sleep(0.1)
    received = serY.readline() 
    print("Y Received --> " + received.decode())
    return received.decode()

@app.route('/api/move/<player>/<spot>')
def api_start():
    serX.reset_input_buffer() # Just in case
    serY.reset_input_buffer() # Just in case
    command = f'{spot}\n'
    print("Sent -->", command)
    if {player} == "X":
        serX.write(command.encode())
        return wait_for_reply_X()
    else:
        serY.write(command.encode())
        return wait_for_reply_Y()
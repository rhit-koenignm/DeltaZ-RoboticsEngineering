import gpiozero as gz
from flask import Flask
import serial
import time

app = Flask(__name__)
print("Connecting")
serX = serial.Serial("/dev/ttyUSB0", baudrate = 9600, timeout=10)
# serO = serial.Serial("/dev/ttyACM1", baudrate = 9600, timeout=10)
print("Connected")
posX = 5
posO = 175
# servo = gz.Servo(17, min_angle= 0, max_angle= 180)

# def main(servo):
#     while True:
#         servo.angle = 0
#         time.sleep(2)
#         servo.angle = 180
#         print("Moved")
#         time.sleep(2)
# # serX.reset_input_buffer()
# # serO.reset_input_buffer()
# main(servo)  
def wait_for_reply_X():
    while(serX.in_waiting == 0):
        time.sleep(0.1)
    received = serX.readline()
    print("X Received --> " + received.decode())
    return received.decode()

# def wait_for_reply_O():
#     while(serO.in_waiting == 0):
#         time.sleep(0.1)
#     received = serO.readline() 
#     print("O Received --> " + received.decode())
#     return received.decode()

@app.route('/api/<player>/<spot>')
def api_move(player, spot):
    serX.reset_input_buffer() # Just in case
    # serO.reset_input_buffer() # Just in case
    command = f'{spot}\n'
    # print("Sent -->", command)
    # print("test")
    # print(servo._angular_range)
    # if player == "X":
        # servo.angle = posX
    time.sleep(0.2)
    serX.write(command.encode())
    return wait_for_reply_X()
    # else:
    #     # servo.angle = posO
    #     time.sleep(0.2)
    #     serX.write(command.encode())
    #     return wait_for_reply_O()

@app.route('/api/connect/<player>/<portNum>')
def api_connect(player, portNum):
    if player == "X":
        portName = f"/dev/{portNum}"
        serX = serial.Serial(portName, baudrate=9600, timeout=10)
        serX.reset_input_buffer()
        message = f"Port {portName} is now open\n"
        serX.write(message.encode())
        return wait_for_reply_X()
    # else:
    #     portName = f"/dev/{portNum}"
    #     serO = serial.Serial(portName, baudrate = 9600, timeout=10)
    #     serO.reset_input_buffer()
    #     message = f"Port {portName} is now open\n"
    #     serO.write(message.encode())
    #     return wait_for_reply_O()




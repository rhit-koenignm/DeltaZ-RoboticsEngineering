#ifndef TicTacToeRobot_h
#define TicTacToeRobot_h

#include "Arduino.h"
#include "DeltaRobot.h"
#include "Servo.h"

#define SERVO1 3
#define SERVO2 3
#define SERVO3 3

class TicTacToeRobot{
    public:
        TicTacToeRobot(int servo1, int servo2, int servo3);
        boolean goToSquare(int square);
        boolean home();
        boolean inkUp();
};

#endif
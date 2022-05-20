#ifndef TicTacToeRobot_h
#define TicTacToeRobot_h

#include "Arduino.h"
#include <DeltaRobot.h>
#include "Servo.h"

#define SERVO1 9
#define SERVO2 10
#define SERVO3 11

class TicTacToeRobot{
    public:
        TicTacToeRobot();
        void setupMotors();
        void goToSquare(int square);
        void home();

    private:
        Delta _robot;
};

#endif
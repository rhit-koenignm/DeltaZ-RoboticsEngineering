#include "Arduino.h"
#include <DeltaRobot.h>
#include "TicTacToeRobot.h"

TicTacToeRobot::TicTacToeRobot() {
    Delta _robot = Delta();
    _robot.setupMotors(SERVO1, SERVO2, SERVO3);
}

/**
 * @brief Homes the robot
 * 
 */
void TicTacToeRobot::home(){
    _robot.goHome();
}

/**
 * @brief Sends the robot to the inkpot so the stamp can get more ink
 * 
 */
void TicTacToeRobot::inkUp(){
    _robot.goTo(30, 30, -45);
    delay(250);
    _robot.goTo(30, 30, -75);
}

/**
 * @brief Marks a valid game square or sends the stamp to the inkpot
 * 
 * @param square -> 0-8; TicTacToe square you want to go to 0 | 1 | 2
 *                                                          3 | 4 | 5
 *                                                          6 | 7 | 8
 * 
 *                  9 will send the robot to the inkpot
 */
void TicTacToeRobot::goToSquare(int square){
    switch(square){
        case 0:
            _robot.goTo(20, 20, -45);
            delay(250);
            _robot.goTo(20, 20, -75);
            break;
        case 1:
            _robot.goTo(0, 20, -45);
            delay(250);
            _robot.goTo(0, 20, -75);
            break;
        case 2:
            _robot.goTo(-20, 20, -45);
            delay(250);
            _robot.goTo(-20, 20, -75);
            break;
        case 3:
            _robot.goTo(20, 0, -45);
            delay(250);
            _robot.goTo(20, 0, -75);
            break;
        case 4:
            _robot.goTo(0, 0, -45);
            delay(250);
            _robot.goTo(0, 0, -75);
            break;
        case 5:
            _robot.goTo(-20, 0, -45);
            delay(250);
            _robot.goTo(-20, 0, -75);
            break;
        case 6:
            _robot.goTo(20, -20, -45);
            delay(250);
            _robot.goTo(20, -20, -75);
            break;
        case 7:
            _robot.goTo(0, -20, -45);
            delay(250);
            _robot.goTo(0, -20, -75);
            break;
        case 8:
            _robot.goTo(-20, -20, -45);
            delay(250);
            _robot.goTo(-20, -20, -75);
            break;
        case 9:
            inkUp();
        default:
            Serial.println("You did not enter a valid move");
    }
}


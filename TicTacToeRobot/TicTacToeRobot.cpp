#include "Arduino.h"
#include <DeltaRobot.h>
#include "TicTacToeRobot.h"
#include "Servo.h"

TicTacToeRobot::TicTacToeRobot() {
    
}

/**
 * @brief Attaches the servos to the proper pins
 * 
 */
void TicTacToeRobot::setupMotors(){
    _robot.setupMotors(SERVO1, SERVO2, SERVO3);
}


/**
 * @brief Homes the robot
 * 
 */
void TicTacToeRobot::home(){
    Serial.println("Go Home");

    _robot.goHome();
}

/**
 * @brief Sends the robot to the inkpot so the stamp can get more ink
 * 
 */
void TicTacToeRobot::inkUp(){
    Serial.println("Get some ink");

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
    Serial.println(String("Move to square ") + square);

    switch(square){
        case 0:
            _robot.goTo(20, 20, -50);
            delay(250);
            _robot.goTo(20, 20, -75);
            delay(500);
            home();
            break;
        case 1:
            _robot.goTo(0, 20, -50);
            delay(250);
            _robot.goTo(0, 20, -75);
            delay(500);
            home();
            break;
        case 2:
            _robot.goTo(-20, 20, -50);
            delay(250);
            _robot.goTo(-20, 20, -75);
            delay(500);
            home();
            break;
        case 3:
            _robot.goTo(20, 0, -50);
            delay(250);
            _robot.goTo(20, 0, -75);
            delay(500);
            home();
            break;
        case 4:
            _robot.goTo(0, 0, -50);
            delay(250);
            _robot.goTo(0, 0, -75);
            delay(500);
            home();
            break;
        case 5:
            _robot.goTo(-20, 0, -50);
            delay(250);
            _robot.goTo(-20, 0, -75);
            delay(500);
            home();
            break;
        case 6:
            _robot.goTo(20, -20, -50);
            delay(250);
            _robot.goTo(20, -20, -75);
            delay(500);
            home();
            break;
        case 7:
            _robot.goTo(0, -20, -50);
            delay(250);
            _robot.goTo(0, -20, -75);
            delay(500);
            home();
            break;
        case 8:
            _robot.goTo(-20, -20, -50);
            delay(250);
            _robot.goTo(-20, -20, -75);
            delay(500);
            home();
            break;
        case 9:
            inkUp();
            delay(500);
            home();
        default:
            Serial.println("You did not enter a valid move");
    }
}


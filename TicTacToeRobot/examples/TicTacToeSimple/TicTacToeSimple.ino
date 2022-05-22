#include "TicTacToeRobot.h"

TicTacToeRobot rob;
String inputString = "";
bool stringComplete = false;
int pos = 0;

void setup(){
  Serial.begin(9600);
  inputString.reserve(200);
  rob.setupMotors();

  rob.home();
  delay(2000);

  // for (int i = 0; i < 9; i++){
  //   rob.goToSquare(i);
  //   delay(2000);
  // }
}

void loop(){
  // Uncomment to manually send the robot to valid TicTacToe positions
    if(stringComplete){
        inputString.trim();
        pos = inputString.toInt();

        if(pos >= 0 || pos < 10){
            rob.goToSquare(pos);
        }else{
            Serial.println("You did not enter a valid position");
        }

      inputString = "";
      stringComplete = false;
    }

}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    if (inChar == '\n') { 
      stringComplete = true;
    } else {
      inputString += inChar;
    }
  }
}
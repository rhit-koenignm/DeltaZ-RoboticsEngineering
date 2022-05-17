#include "TicTacToeRobot.h"

TicTacToeRobot rob = TicTacToeRobot();
String inputString = "";
bool stringComplete = false;
int pos = 0;

void setup(){
    Serial.begin(9600);
    inputString.reserve(200);
    rob.home();
    delay(2000);
}

void loop(){
  // Serial.println(stringComplete);
  //   if(stringComplete){
  //       inputString.trim();
  //       pos = inputString.toInt();

  //       if(pos >= 0 || pos < 10){
  //           rob.goToSquare(pos);
  //       }else{
  //           Serial.println("You did not enter a valid position");
  //       }

  //     inputString = "";
  //     stringComplete = false;
  //   }

  // for (int i = 0; i < 9; i++){
  //   rob.goToSquare(i);
  //   delay(2000);
  // }
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
////chap11_0
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
PFont myFont;

int usePin[] = {2,3,4,6,7,8,9};
int number = 2;
int intMatrix[][]={
  {0,0,1,1,0,0,0},  //1
  {0,1,1,1,1,0,1},  //3
  {1,1,1,1,1,1,1},  //8
};

void setup(){
  size(400,100);
  arduino = new Arduino(
  this, "/dev/cu.usbserial-14P54830");
  myFont = loadFont(
  "CourierNewPSMT-48.vlw");
  textFont(myFont, 32);
  for(int a = 0; a < usePin.length; a++){
    arduino.pinMode(
      usePin[a],Arduino.OUTPUT);
  }
}

void draw(){
    background(255);
    fill(0);
    String strNum = "Num = " + number;
    text(strNum,15,50);
    for(int a =0; a < usePin.length; a++){
      arduino.digitalWrite(
        usePin[a], intMatrix[number][a]);
    }
}

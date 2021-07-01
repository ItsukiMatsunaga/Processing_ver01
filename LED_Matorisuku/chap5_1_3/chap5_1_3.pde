//chap5_1_3  hatten1
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
PFont myFont;

int preline[] = {0, 0, 0, 0, 0, 0, 0, 0};
int ANODEPIN[] = {2, 3, 4, 5, 6, 7, 8, 9};
int CATHODEPIN[] = {10, 11, 12, 14, 15, 16, 17, 18};
int usePin5 = 5;
int usePin6 = 6;
int usePin7 = 7;
int input5,input6;
int status=0; //0: up, 1: right, 2: down, 3: left

int mat_up[][] = {
  {0, 0, 0, 1, 0, 0, 0, 0}, 
  {0, 0, 1, 0, 0, 0, 0, 0}, 
  {0, 1, 0, 0, 0, 0, 0, 0}, 
  {1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1}, 
  {0, 1, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 1, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 1, 0, 0, 0, 0}, 
};

int mat_down[][] = {
  {0, 0, 0, 0, 1, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 1, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 1, 0}, 
  {1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1}, 
  {0, 0, 0, 0, 0, 0, 1, 0}, 
  {0, 0, 0, 0, 0, 1, 0, 0}, 
  {0, 0, 0, 0, 1, 0, 0, 0}, 
};

int mat_left[][] = {
  {0, 0, 0, 1, 1, 0, 0, 0}, 
  {0, 0, 1, 1, 1, 1, 0, 0}, 
  {0, 1, 0, 1, 1, 0, 1, 0}, 
  {1, 0, 0, 1, 1, 0, 0, 1}, 
  {0, 0, 0, 1, 1, 0, 0, 0}, 
  {0, 0, 0, 1, 1, 0, 0, 0}, 
  {0, 0, 0, 1, 1, 0, 0, 0}, 
  {0, 0, 0, 1, 1, 0, 0, 0}, 
};

int mat_right[][] = {
  {0, 0, 0, 1, 1, 0, 0, 0}, 
  {0, 0, 0, 1, 1, 0, 0, 0}, 
  {0, 0, 0, 1, 1, 0, 0, 0}, 
  {0, 0, 0, 1, 1, 0, 0, 0}, 
  {1, 0, 0, 1, 1, 0, 0, 1}, 
  {0, 1, 0, 1, 1, 0, 1, 0}, 
  {0, 0, 1, 1, 1, 1, 0, 0}, 
  {0, 0, 0, 1, 1, 0, 0, 0}, 
};

void setup() {
  size(800, 230);
  arduino = new Arduino(
  this, "/dev/cu.usbserial-14P54830",57600);
  delay(1000);

  for (int ano = 0; ano < 8; ano++) {
    arduino.pinMode(ANODEPIN[ano], Arduino.OUTPUT);
    arduino.digitalWrite(ANODEPIN[ano], Arduino.LOW);
  }
  for (int cat = 0; cat < 8; cat++) {
    arduino.pinMode(CATHODEPIN[cat], Arduino.OUTPUT);
    arduino.digitalWrite(CATHODEPIN[cat], Arduino.HIGH);
  }
  
  myFont = loadFont("CourierNewPSMT-48.vlw");
  textFont(myFont, 30);
  frameRate(30);
}

void draw() {
  background(120);
  input5 = arduino.analogRead(usePin5);
  input6 = arduino.analogRead(usePin6);
  
  fill(255);
  text("X=" + input5, 15, 30);
  text("Y=" + input6, 15, 60);
  
  //Visualise Analog Input Value
  noStroke();
  fill(255);
  rect(235, 10, (input5 / 4),20);
  rect(235, 40, (input6 / 4),20);
  stroke(255, 0,0);
  line(235, 5, 235, 125);
  line(490, 5, 490, 125);
  
  if (input5<450 && input6 > 450 && input6 <600) {
    status = 0;
  } else if (input5>600 && input6 > 450 && input6 <600) {
    status = 2;
  } else if (input6<450 && input5 > 450 && input5 < 600){
    status = 1;
  } else if (input6>600 && input5 > 450 && input5 < 600){
    status = 3;
  }
  
  switch(status) {
    case 0:
      showMatrix(mat_up);
      break;
    case 1:
      showMatrix(mat_right);
      break;
    case 2:
      showMatrix(mat_down);
      break;
    case 3:
      showMatrix(mat_left);
      break;
  }
}

void showMatrix(int matrix[][]) {
  for (int cat=0; cat<8; cat++) {
    for (int ano=0; ano<8; ano++) {
      if(preline[ano]!=matrix[ano][cat]){
        arduino.digitalWrite(ANODEPIN[ano], matrix[ano][cat]);
        preline[ano]=matrix[ano][cat];
      }
    }
    arduino.digitalWrite(CATHODEPIN[cat], Arduino.LOW);
    delay(3);
    arduino.digitalWrite(CATHODEPIN[cat], Arduino.HIGH);
  }
}

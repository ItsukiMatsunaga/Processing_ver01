//chap5_1_2_1
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
PFont myFont;

int ANODEPIN[] = {2, 3, 4, 5, 6, 7, 8, 9};
int CATHODEPIN[] = {10, 11, 12, 14, 15, 16, 17, 18};

int mat_A[][] = {
  {0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 1, 1, 0, 0, 0, 0, 0}, 
  {1, 1, 1, 0, 0, 0, 1, 0}, 
  {0, 0, 1, 1, 1, 0, 0, 1}, 
  {0, 0, 1, 1, 1, 1, 1, 0}, 
  {0, 0, 1, 1, 1, 1, 1, 0}, 
  {0, 1, 0, 0, 0, 0, 1, 0}, 
  {1, 0, 0, 0, 0, 0, 0, 1}, 
};

int mat_B[][] = {
  {0, 1, 1, 0, 0, 0, 1, 0}, 
  {1, 1, 1, 0, 0, 0, 0, 1}, 
  {0, 0, 1, 1, 1, 0, 0, 1}, 
  {0, 0, 1, 1, 1, 1, 1, 0}, 
  {0, 0, 1, 1, 1, 1, 1, 0}, 
  {0, 0, 0, 1, 0, 0, 1, 0}, 
  {0, 0, 0, 0, 1, 1, 0, 0}, 
  {0, 0, 0, 1, 0, 0, 0, 0}, 
};

void setup() {
  size(300, 300);
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
  if (second()%2==0) {
    showMatrix(mat_A);
  } else {
    showMatrix(mat_B);
  }
}

void showMatrix(int matrix[][]) {
  for (int cat=0; cat<8; cat++) {
    for (int ano=0; ano<8; ano++) {
      arduino.digitalWrite(ANODEPIN[ano], matrix[ano][cat]);
      
    }
    arduino.digitalWrite(CATHODEPIN[cat], Arduino.LOW);
    delay(3);
    arduino.digitalWrite(CATHODEPIN[cat], Arduino.HIGH);
  }
}

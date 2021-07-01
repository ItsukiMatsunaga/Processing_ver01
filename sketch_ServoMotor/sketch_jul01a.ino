//Savor motor
#include <Servo.h>
Servo myServo;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  myServo.attach(4);
}

void loop() {
  // put your main code here, to run repeatedly:
  myServo.write(180);
  delay(1000);
  myServo.write(90);
  delay(1000);
  
}

//Card Reader
#include <require_cpp11.h>
#include <MFRC522.h>
#include <deprecated.h>
#include <MFRC522Extended.h>

//Motor
#include <Servo.h>
Servo myServo;

#define RST_PIN    9
#define SS_PIN   10

#define MYID "E6 14 7C A6"

MFRC522 mfrc522(SS_PIN, RST_PIN);

//Card reader
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  myServo.attach(4);    //Motor pin
  while(!Serial);
  SPI.begin();
  mfrc522.PCD_Init();
  delay(4);
  mfrc522.PCD_DumpVersionToSerial();
  Serial.println(F("Scan PICC to see UID, SAK, type, and data blocks..."));
}

void loop() {
  // Reset the loop if no new card present on the sensor/reader. This saves the entire process when idle.
  if ( ! mfrc522.PICC_IsNewCardPresent()) {
    return;
  }

  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial()) {
    return;
  }

  // Dump debug info about the card; PICC_HaltA() is automatically called
  String strBuf[mfrc522.uid.size];
  for(byte i = 0; i < mfrc522.uid.size; i++){
    strBuf[i] = String(mfrc522.uid.uidByte[i], HEX);
    if(strBuf[i].length() == 1){
      strBuf[i] = "0" + strBuf[i];
    }
  }

  String strUID = strBuf[0] + " " + strBuf[1] + " " + strBuf[2] + " " + strBuf[3];
  
  Serial.print("Card UID:");
  printHex(mfrc522.uid.uidByte, mfrc522.uid.size);
  Serial.println();
  if ( strUID.equalsIgnoreCase(MYID) ){  // 大文字小文字関係なく比較
      myServo.write(180);
      delay(1000);
      myServo.write(90);
      delay(1000);
      Serial.print("Yes");
      Serial.println();
  }
}

void printHex(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}

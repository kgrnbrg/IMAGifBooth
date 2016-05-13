#include <Bounce2.h>

const int LED_PIN = 4;
const int BUTTON_PIN = 5;

bool ledState = 0;
bool buttonState = 0;
bool buttonRead = 0;
int inByte = 0;

Bounce button = Bounce();

void setup() {
  Serial.begin(9600);
  pinMode(LED_PIN, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  button.attach(BUTTON_PIN);
  button.interval(5);
 
  digitalWrite(2, LOW);
  digitalWrite(3, HIGH);
  digitalWrite(LED_PIN, ledState);
}

void loop() {
  button.update();
  
  if(Serial.available() > 0) {
    inByte = Serial.read();
  }
  if(inByte == '0') {
    ledState = 0;
    digitalWrite(LED_PIN, ledState);
  }
  if(inByte == '1') {
    ledState = 1;
    digitalWrite(LED_PIN, ledState);
  }

  if(button.fell()) {
    Serial.write('1');
  }
}

/*

This sketch is based on the example 'BlinkWithoutDelay' provided
with the Arduino IDE. This sketch compares a stored int with a
collected int (the current time in millis() and then sets the
first LED in sequence as the opposite of whatever its existing
digital state is, waits 1/3 of the overall interval time, and then
does the same for the next LED.

*/

#define GREEN 9
#define BLUE 10
#define RED 11

// Variables will change:
int ledState = LOW;  
long previousMillis = 0; 

long interval = 1000;

void setup() {
  pinMode(GREEN, OUTPUT);
  pinMode(BLUE, OUTPUT);
  pinMode(RED, OUTPUT);
}

void loop() {
  unsigned long currentMillis = millis();
 
  if(currentMillis - previousMillis > interval) {
    // save the last time you blinked the LED 
    previousMillis = currentMillis;   

    // if the LED is off turn it on and vice-versa:
    if (ledState == LOW)
      ledState = HIGH;
    else
      ledState = LOW;

    // set the LED with the ledState of the variable:
    digitalWrite(GREEN, ledState);
    delay(interval/3);
    digitalWrite(BLUE, ledState);
    delay(interval/3);
    digitalWrite(RED, ledState);
  }
}

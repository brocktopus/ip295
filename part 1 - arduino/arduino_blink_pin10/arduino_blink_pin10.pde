/* 
This second blink sketch accompanies a tutorial on using a
pin other than pin 13 and its built-in resistor, so that
students can get an initial feel for using resistors and
understanding Ohm's law more clearly.
*/
void setup() {
  // pin 10 is set up as output, just as pin 13 was in
  // the earlier Blink example.
  pinMode(10, OUTPUT);
}

void loop() {
  digitalWrite(10, HIGH); // LED is turned on
  delay(1000);            // After 1 second (1000 ms)
  digitalWrite(10, LOW);  // LED is turned off
  delay(1000);            // with another 1 second pause
}

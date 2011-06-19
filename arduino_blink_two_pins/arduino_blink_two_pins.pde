/*
This sketch demonstrates the ability to define multiple actions
at once, building off of the basic on/off & delay functionalities
students will be familiar with by this point.
*/
#define BLUE 9
#define RED 10

void setup() {
  pinMode(BLUE, OUTPUT);
  pinMode(RED, OUTPUT);
}

void loop() {
  digitalWrite(BLUE, HIGH);
  digitalWrite(RED, HIGH);
  delay(1000);
  digitalWrite(BLUE, LOW);
  digitalWrite(RED, LOW);
  delay(1000);
}

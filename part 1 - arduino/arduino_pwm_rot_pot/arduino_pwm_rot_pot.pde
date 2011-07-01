/*
We'll set up the potentiometer to use analog pin 2 and
we'll put the LED on one of the PWM pins (in this case, 9).

Finally, we'll use i as an int variable to record the input
of the potentiometer and translate that (as 1/4 the amount) to
the brightness of the LED.
*/

int potPin = 2;
int LED = 9;
int i = 0;

void setup() {
  pinMode(LED, OUTPUT);
}

void loop() {
  i = analogRead(potPin);
  analogWrite(LED, i/4);
}


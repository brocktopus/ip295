// This is the 'wrong' way to make alternating PWMs, as
// the code for each LED to fade is not quite in sync with 
// that of the other - as you'll see if you upload this sketch

#define BLUE 9
#define RED 11
int i = 0;
int j = 255;

void setup() {
  pinMode(BLUE, OUTPUT);
  pinMode(RED, OUTPUT);
}

void loop() {
  for (i = 0; i < 255; i++) {
    analogWrite(BLUE, i);
  } 
  for (j = 255; j > 0; j--) {
    analogWrite(RED, j);
    delay(5);
  }
  for (j = 0; j < 255; j++) {
    analogWrite(RED, j);
  }
  for (i = 255; i > 0; i--) {
    analogWrite(BLUE, i);
    delay(5);
  }
}

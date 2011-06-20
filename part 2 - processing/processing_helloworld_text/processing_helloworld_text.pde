/*
One of the initial steps we'll have to take in order to view
text in a Processing window is to generate the font that will
be used to draw text.

To generate a font, go to the 'Tools' menu, then 'Create Font'
and choose a font. In the setup() below, you'll define the
font you use by that file name - and if you look in your
Processing sketchbook and the directory for this sketch, you'll
see a 'data' directory within it that includes a file for the
font you've generated.
*/

PFont arial;

void setup() {
  arial = loadFont("ArialMT-24.vlw");
  size(200,200);
  background(255);
  
/*
Just like with the loop() used by Arduino, Processing will
continually refer to the draw() function as a looping act. With
the line below, we've asked for the draw() function to be called
only once.
*/
  noLoop();
}

void draw() {
/*
What we're doing first is telling the sketch to fill whatever
it draws with the color 0 - RGB shorthand for 'black'. Then,
it fills in the text we've asked it to draw with that color,
beginning 20 pixels to the right and 20 pixels down from the
top left corner (X-Y coordinate 0,0).

After that, we've added another line of text that is filled
with a different color value - a lighter gray.
*/
  fill(0);
  text("Hello world!", 20, 20);
  fill(120);
  text("Different color!", 20, 60);
}

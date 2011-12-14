/*----------------------------------------------------

A "networked lamp" connecting together the Arduino
microcontroller and the Processing language, inspired
by the RSS networked lamp provided in the book
_Getting Started with Arduino_ by Massimo Banzi.

Author: Kevin Brock ( http://www4.ncsu.edu/~kmbrock )

with some Twitter4J -> Processing help from Erin of
( http://www.robotgrrl.com )

----------------------------------------------------*/

/*
To control the Arduino through Processing, we need to use
 the Arduino-Processing library, available from 
 ( http://www.arduino.cc/playground/Interfacing/Processing ).
 
 To prepare the Arduino, we just need to upload to it the Standard
 Firmata library, which is packaged with the Arduino IDE.
 */
import cc.arduino.*;
import processing.serial.*;

/*
To connect to Twitter, we need to use the twitter4j library,
 available from ( http://www.twitter4j.org ).
 
 Some of these libraries are used in some OSes and not others.
 You'll have to check the output window at the bottom to see
 which your program asks for. The following is set for Ubuntu 11.04
 */
import twitter4j.conf.*;
import twitter4j.internal.async.*;
import twitter4j.internal.org.json.*;
import twitter4j.internal.logging.*;
import twitter4j.json.*;
import twitter4j.internal.util.*;
import twitter4j.management.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import twitter4j.util.*;
import twitter4j.internal.http.*;
import twitter4j.*;
import twitter4j.internal.json.*;

/*
Some of this Twitter4J code was based on the work done by
 Erin of robotgrrl.com, who plotted out some initial ways for
 Processing users who weren't knowledgeable about Java to
 incorporate the fundamental capabilities of Twitter4J into
 their Processing projects.
 
 You can see Erin's code at
 ( http://robotgrrl.com/blog/2011/02/21/simple-processing-twitter/ ).
 
 Erin's initial comment & CC license info:
 -----------------------------
 Just a simple Processing and Twitter thingy majiggy
 RobotGrrl.com
 Code licensed under:
 CC-BY
 -----------------------------
 */


Twitter twitter = new TwitterFactory().getInstance();

/*
I'll note that, because we're only reading publicly-available tweets,
I've taken out login- and write-related code. If you want to see how
those function, check the robotgrrl link provided above.
*/

int lastTime;
int interval = 30;
PFont font;
color c;
String cs;
int light = 0;
int n;

// Here are the terms that Processing will search for.
// The first 3, in this case, reflect class-related info.
String[] keyword = { 
  "processing", 
  "arduino", 
  "physical computing", 
  // The second 3 reflect institution-related info.
  "CRDM", 
  "#ncstate", 
  "CHASS", 
  // The third 3 look up @mentions of colleagues.
  "@dmrieder", 
  "@ikatowi", 
  "@drgruber"
};

// These are the search results counter variables. They will
// keep track of how many results each keyword[] index has
// registered.
int[] counter = {
  0, 0, 0, 0, 0, 0, 0, 0, 0
};

// These are the numbers that the counters are converted to
// for LED-specific PWM / RGB purposes.
int[] counter_map = {
  0, 0, 0, 0, 0, 0, 0, 0, 0
};

int r_total = 0;
int g_total = 0;
int b_total = 0;

int max_light = 255;
int max_tweets = 100;

// These are the variables pointing to Arduino PWM output pins.
int green1 = 5;
int green2 = 6;
int green3 = 7;
int blue1 = 8;
int blue2 = 9;
int blue3 = 10;
int red1 = 11;
int red2 = 12;
int red3 = 13;

// These variables point to Arduino analog input pins.
int pot_right = 0;
int pot_left = 3;
int pot_slide = 2;

Arduino arduino;

void setup() {

  // First, set up Arduino functionality.
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(green1, Arduino.OUTPUT);
  arduino.pinMode(green2, Arduino.OUTPUT);
  arduino.pinMode(green3, Arduino.OUTPUT);
  arduino.pinMode(blue1, Arduino.OUTPUT);
  arduino.pinMode(blue2, Arduino.OUTPUT);
  arduino.pinMode(blue3, Arduino.OUTPUT);
  arduino.pinMode(red1, Arduino.OUTPUT);
  arduino.pinMode(red2, Arduino.OUTPUT);
  arduino.pinMode(red3, Arduino.OUTPUT);  
  arduino.pinMode(pot_right, Arduino.INPUT);
  arduino.pinMode(pot_left, Arduino.INPUT);
  arduino.pinMode(pot_slide, Arduino.INPUT);

  size(640, 480);
  frameRate(1);
  background(0);

  font = loadFont("ArialMT-18.vlw");
  textFont(font);
  fill(255);

  // Let's grab our first set of Twitter data for when the
  // screen is drawn initially.
  getSearchTweets();
}


void draw() {

  background(c);
  n = floor((interval - ((millis()-lastTime)/1000)));
  r_total = (counter_map[0] + counter_map[1] + counter_map[2])/3;
  g_total = (counter_map[3] + counter_map[4] + counter_map[5])/3;
  b_total = (counter_map[6] + counter_map[7] + counter_map[8])/3;

  c = color(r_total, g_total, b_total);
  cs = "#" + hex(c, 6);

  // Let's begin defining what gets drawn to the sketch window.
  text("Arduino Networked Lamp", 10, 40);

  text("Next update in " + n + " seconds", 10, 100);

  text("phys. computing", 10, 200);
  text(" " + (counter[0] + counter[1] + counter[2]), 150, 200);
  rect(200, 172, r_total, 28);

  text("nc state", 10, 240);
  text(" " + (counter[3] + counter[4] + counter[5]), 150, 240);
  rect(200, 212, g_total, 28);

  text("@mentions", 10, 280);
  text(" " + (counter[6] + counter[7] + counter[8]), 150, 280);
  rect(200, 252, b_total, 28);

  text("sending", 10, 340);
  text(cs, 200, 340);
  text("light level", 10, 380);
  rect(200, 352, light/10.23, 28);
  // This is the end of the information drawn to the sketch window.

  if ((arduino.analogRead(pot_right) == 0) && (arduino.analogRead(pot_left) == 0) && (arduino.analogRead(pot_slide) == 0)) {
    arduino.digitalWrite(red1, Arduino.LOW);
    arduino.digitalWrite(red2, Arduino.LOW);
    arduino.digitalWrite(red3, Arduino.LOW);
    arduino.digitalWrite(blue1, Arduino.LOW);
    arduino.digitalWrite(blue2, Arduino.LOW);
    arduino.digitalWrite(blue3, Arduino.LOW);
    arduino.digitalWrite(green1, Arduino.LOW);
    arduino.digitalWrite(green2, Arduino.LOW);
    arduino.digitalWrite(green3, Arduino.LOW);
  } 
  else {

    println(max_tweets + ", " + interval + ", " + max_light);

    if (floor(map(arduino.analogRead(pot_left), 0, 1023, 10, 3600)) != interval) {
      interval = floor(map(arduino.analogRead(pot_left), 0, 1023, 10, 3600));
    }

    /*
     Once the countdown hits zero, let's run through everything
     we need to in order to update the Twitter results.
     Note: with 9 searches happening almost simultaneously, it's
     likely there will be a second or two of lag time before you
     see results displayed on the screen or through the Arduino.
     */
    if (n <= 0) {
      counterFlush();
      grabAnalogData();
      getSearchTweets();
      pushLights();
      lastTime = millis();
    }
  }
}

// Here, we reset all the counters to 0 to get fresh numbers
// from each keyword search.
void counterFlush() {
  for (int i = 0; i < counter.length; i++) {
    counter[i] = 0;
  }
}

/*
Since some of the parameters for the searches rely on the
 Arduino's potentiometer readings, we need to check what the
 pots are currently set at.
 */
void grabAnalogData() {
  max_tweets = floor(map(arduino.analogRead(pot_right), 0, 1023, 5, 100));
  interval = floor(map(arduino.analogRead(pot_right), 0, 1023, 10, 3600));
  max_light = floor(map(arduino.analogRead(pot_slide), 0, 1023, 0, 255));
}


// Search for tweets.
void getSearchTweets() {

  /*
   This particular sketch checks tweets from the same day as the
   current date. Twitter requires a specific format for this
   field, so we have to set up a string that makes sure the date
   is inputted correctly.
   */
  String thisyear = "" + year();
  String thismonth;
  String thisday;

  if (month() < 10) {
    thismonth = "-0" + month();
  }
  else {
    thismonth = "-" + month();
  }

  if (day() < 10) {
    thisday = "-0" + day();
  }
  else {
    thisday = "-" + day();
  }

  String date = "" + thisyear + thismonth + thisday;

  try {

    // We'll run this for() loop once for every index of counter[].
    for (int j = 0; j < counter.length; j++) {

      // We'll check between 5 and 500 results for each keyword[] index.
      for (int i = 1; i < 6; i++) {
        Query query = new Query(keyword[j]);
        query.setPage(i);
        query.setRpp(max_tweets);
        query.setSince(date);
        QueryResult result = twitter.search(query);
        ArrayList tweets = (ArrayList) result.getTweets();
        counter[j] += tweets.size();
        query = null;
        result = null;
        tweets = null;
      }
    }    

    // Next, we'll set each keyword[] index's counter to the size
    // of the corresponding counter_map[] index.
    for (int i = 0; i < counter_map.length; i++) {
      counter_map[i] = int(map(counter[i], 0, 500, 0, max_light));
    }
  }
  catch (TwitterException e) {
    println("Could not connect.");
    println(e);
    text("Could not connect.", 10, 30, 600, 400);
  }
}

// Finally, we'll set all of the Arduino LEDs to the proper
// brightness based upon the corresponding counter_map[] index.
void pushLights() {
  arduino.analogWrite(red1, counter_map[0]);
  arduino.analogWrite(red2, counter_map[1]);
  arduino.analogWrite(red3, counter_map[2]);

  arduino.analogWrite(green1, counter_map[3]);
  arduino.analogWrite(green2, counter_map[4]);
  arduino.analogWrite(green3, counter_map[5]);

  arduino.analogWrite(blue1, counter_map[6]);
  arduino.analogWrite(blue2, counter_map[7]);
  arduino.analogWrite(blue3, counter_map[8]);
}


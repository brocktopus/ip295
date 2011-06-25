/*
 Some of these libraries are used in some OSes and not others.
 You'll have to check the output window at the bottom to see
 which your program asks for. The following is set for Ubuntu 11.04
*/

import twitter4j.conf.*;
import twitter4j.internal.org.json.*;
import twitter4j.internal.logging.*;
//import twitter4j.json.*;
import twitter4j.internal.util.*;
//import twitter4j.auth.*;
import twitter4j.api.*;
import twitter4j.http.*;
import twitter4j.util.*;
import twitter4j.internal.http.*;
import twitter4j.*;
//import twitter4j.internal.json.*;

/*
 Just a simple Processing and Twitter thingy majiggy
 RobotGrrl.com
 Code licensed under:
 CC-BY
*/

// First step is to register your Twitter application at dev.twitter.com
// Once registered, you will have the info for the OAuth tokens
// You can get the Access token info by clicking on the button on the
// right on your twitter app's page
// Good luck, and have fun!

// This is where you enter your Oauth info
static String OAuthConsumerKey = "";
static String OAuthConsumerSecret = "";

// This is where you enter your Access Token info
static String AccessToken = "";
static String AccessTokenSecret = "";

Twitter twitter = new TwitterFactory().getInstance();
RequestToken requestToken;

int lastTime;
int interval = 10;
PFont font;
color c;
String cs;
int light = 0;

// Here are the terms that Processing will search for
String keyword1 = "arduino";
String keyword2 = "peace";
String keyword3 = "love";

// These are the search results counters
int counter1 = 0;
int counter2 = 0;
int counter3 = 0;

void setup() {
  
  size(640, 480);
  frameRate(10);
  background(0);

  font = loadFont("ArialMT-18.vlw");
  textFont(font);
  fill(255);

  connectTwitter();
  getSearchTweets();
}


void draw() {

  background(c);
  int n = (interval - ((millis()-lastTime)/1000));
  
  c = color(counter1, counter2, counter3);
  cs = "#" + hex(c,6);
  
  text("Arduino Networked Lamp", 10, 40);
  
  text("Next update in " + n + " seconds", 10, 100);

  text(keyword1, 10, 200);
  text(" " + counter1, 130, 200);
  rect(200, 172, counter1, 28);
  
  text(keyword2, 10, 240);
  text(" " + counter2, 130, 240);
  rect(200, 212, counter2, 28);
  
  text(keyword3, 10, 280);
  text(" " + counter3, 130, 280);
  rect(200, 252, counter3, 28);
  
  text("sending", 10, 340);
  text(cs, 200, 340);
  text("light level", 10, 380);
  rect(200, 352, light/10.23, 28);
  
  if (n <= 0) {
    getSearchTweets();
    lastTime = millis();
  }
}


// Initial connection
void connectTwitter() {

  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}

// Loading up the access token
private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
}

// Search for tweets
void getSearchTweets() {

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
    Query query1 = new Query(keyword1);    
    query1.setRpp(64); // Get the 64 most recent search results  
    query1.setSince(date);
    QueryResult result1 = twitter.search(query1);    
    ArrayList tweets1 = (ArrayList) result1.getTweets();    
    
    Query query2 = new Query(keyword2);    
    query2.setRpp(64); // Get the 64 most recent search results 
//    query2.setSince(date); 
    QueryResult result2 = twitter.search(query2);    
    ArrayList tweets2 = (ArrayList) result2.getTweets();
    
    Query query3 = new Query(keyword3);    
    query3.setRpp(64); // Get the 64 most recent search results 
//    query3.setSince(date); 
    QueryResult result3 = twitter.search(query3);    
    ArrayList tweets3 = (ArrayList) result3.getTweets();    

counter1 = tweets1.size() * 4;
counter2 = tweets2.size() * 4;
counter3 = tweets3.size() * 4;

  } 
    catch (TwitterException e) {
    println("Could not connect.");
    text("Could not connect.", 10, 30, 600, 400);
  }
}


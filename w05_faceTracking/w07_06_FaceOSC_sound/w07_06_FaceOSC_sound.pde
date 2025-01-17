// Based on: Face It by Daniel Shiffman / ITP Fall 2013 
// https://github.com/shiffman/Face-It
// https://github.com/kylemcdonald/ofxFaceTracker

// Please download FaceOSC here:
// https://github.com/kylemcdonald/ofxFaceTracker/releases/download/v1.1/FaceOSC-v1.1.zip

// IMA NYU Shanghai
// Kinetic Interfaces
// MOQN
// Oct 13 2016


import processing.sound.*;
import oscP5.*;
OscP5 oscP5;

PVector posePosition;
PVector poseOrientation;

boolean found;
float eyeLeftHeight;
float eyeRightHeight;
float mouthHeight;
float mouthWidth;
float nostrilHeight;
float leftEyebrowHeight;
float rightEyebrowHeight;

float poseScale;

color c;
float prev_rightEyebrowHeight;

SoundFile sound;


void setup() {
  size(640, 480);
  frameRate(30);
  noStroke();

  posePosition = new PVector();
  poseOrientation = new PVector();

  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "eyebrowLeftReceived", "/gesture/eyebrow/left");
  oscP5.plug(this, "eyebrowRightReceived", "/gesture/eyebrow/right");
  oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
  oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
  oscP5.plug(this, "jawReceived", "/gesture/jaw");
  oscP5.plug(this, "nostrilsReceived", "/gesture/nostrils");
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseScale", "/pose/scale");
  
  sound = new SoundFile(this, "sound.wav");
}


void draw() {
  if (mouthHeight > 3) {
    background(random(255),random(255),random(255));
  } else {
    background(255);
  }
  

  if (found) {
    translate(posePosition.x, posePosition.y);
    //translate(width/2, height/2);
    scale(poseScale*0.5);
    noFill();

    fill(c,200);
    ellipse(0, 0, 100, 90);
    fill(0);
    ellipse(0, 20, mouthWidth*2, mouthHeight*2);
    ellipse(-3, nostrilHeight, 2, 2);
    ellipse(3, nostrilHeight, 2, 2);
    ellipse(-20, eyeLeftHeight*-8, 5, 5);
    ellipse(20, eyeRightHeight*-8, 5, 5);

    float diffEyebrow = abs(rightEyebrowHeight-prev_rightEyebrowHeight);
    //println(diff);
    if (diffEyebrow > 0.4) {
      c = color(random(150,255),random(150,255),random(150,255));
      sound.play();
    }
    
    rectMode(CENTER);
    rect(-20, leftEyebrowHeight * -5, 25, 5);
    rect(20, rightEyebrowHeight * -5, 25, 5);
  }


  prev_rightEyebrowHeight = rightEyebrowHeight;
}


public void mouthWidthReceived(float w) {
  //println("mouth Width: " + w);
  mouthWidth = w;
}

public void mouthHeightReceived(float h) {
  //println("mouth height: " + h);
  mouthHeight = h;
}

public void eyebrowLeftReceived(float h) {
  //println("eyebrow left: " + h);
  leftEyebrowHeight = h;
}

public void eyebrowRightReceived(float h) {
  //println("eyebrow right: " + h);
  rightEyebrowHeight = h;
}

public void eyeLeftReceived(float h) {
  //println("eye left: " + h);
  eyeLeftHeight = h;
}

public void eyeRightReceived(float h) {
  //println("eye right: " + h);
  eyeRightHeight = h;
}

public void jawReceived(float h) {
  //println("jaw: " + h);
}

public void nostrilsReceived(float h) {
  //println("nostrils: " + h);
  nostrilHeight = h;
}

public void found(int i) {
  //println("found: " + i); // 1 == found, 0 == not found
  found = i == 1;
}

public void posePosition(float x, float y) {
  //println("pose position\tX: " + x + " Y: " + y );
  posePosition.x = x;
  posePosition.y = y;
}

public void poseScale(float s) {
  //println("scale: " + s);
  poseScale = s;
}

public void poseOrientation(float x, float y, float z) {
  //println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
  poseOrientation.x = x;
  poseOrientation.y = y;
  poseOrientation.z = z;
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.isPlugged()==false) {
    //println("UNPLUGGED: " + theOscMessage);
  }
}
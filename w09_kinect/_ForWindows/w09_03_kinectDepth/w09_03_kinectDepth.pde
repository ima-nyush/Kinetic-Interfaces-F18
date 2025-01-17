// IMA NYU Shanghai
// Kinetic Interfaces
// MOQN
// Mar 28 2018


import KinectPV2.*;


KinectPV2 kinect2;
PImage depthImg;

int thresholdMin = 1; // let's not use 0
int thresholdMax = 4499;


void setup() {
  size(512, 424, P2D);
  
  kinect2 = new KinectPV2(this);
  kinect2.enableDepthImg(true);
  kinect2.init();

  // Allocate a blank image
  depthImg = new PImage(KinectPV2.WIDTHDepth, KinectPV2.HEIGHTDepth, ARGB);
}


void draw() {
  int[] rawDepth = kinect2.getRawDepthData();
  int w = KinectPV2.WIDTHDepth;
  int h = KinectPV2.HEIGHTDepth;
  depthImg.loadPixels();
  for (int i=0; i < rawDepth.length; i++) {
    int x = i % w;
    int y = floor(i / w);
    int depth = rawDepth[i]; // z
    
    // reset the pixel value (make it transparent)
    depthImg.pixels[i] = color(0, 0);
    if ( depth >= thresholdMin
      && depth <= thresholdMax
      && depth != 0) {

      float r = map(depth, thresholdMin, thresholdMax, 255, 0);
      float b = map(depth, thresholdMin, thresholdMax, 0, 255);

      depthImg.pixels[i] = color(r, 0, b);
    }
  }
  depthImg.updatePixels();

  background(0);
  image(kinect2.getDepthImage(), 0, 0);
  image(depthImg, 0, 0);

  fill(255);
  text(frameRate, 10, 20);
  text("Drag your mouse to adjust the thresholds.", 10, 60);
  text(thresholdMin + " - " + thresholdMax, 10, 80);
}


void mousePressed() {
  thresholdMin = (int)map(mouseX, 0, width, 0, 4499);
}


void mouseDragged() {
  thresholdMax = (int)map(mouseX, 0, width, 0, 4499);
}

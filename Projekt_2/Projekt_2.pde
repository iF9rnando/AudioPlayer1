import ddf.minim.*;
import processing.sound.*;
int startTime;
int elapsedTime;

float[] amplitudes = new float[15]; // Array to store the amplitudes
int amplitudeIndex = 0; // Index for storing amplitudes

boolean greenStroke = false;

Minim minim;
AudioPlayer player;

import controlP5.*;

ControlP5 cp5;

int startColor;
int targetColor;
int currentColor;
float transitionSpeed = 0.01; // Adjust this value to control the speed of the transition

boolean isPaused = true;

Rect[] rectangles;

void setup() {
  size(800, 800);
  noStroke();
  textSize(20);
  startTime = millis();

  // Create a new Minim object
  minim = new Minim(this);

  // Load an audio file
  player = minim.loadFile("Lil Baby x Gunna - Drip Too Hard.mp3");
  
   // Create a new ControlP5 object
  cp5 = new ControlP5(this);
  
  // Create a new button
  cp5.addButton("playButton")
              .setPosition(20, 740)
              .setSize(40, 40)
              .setColorBackground(#202020)
              .setColorForeground(#303030)
              .setCaptionLabel("Play");
              
              // Create a new button
  cp5.addButton("pauseButton")
              .setPosition(80, 740)
              .setSize(40, 40)
              .setColorBackground(#202020)
              .setColorForeground(#303030)
              .setCaptionLabel("Pause");
              
              // Create a new button
  cp5.addButton("resetButton")
              .setPosition(140, 740)
              .setSize(40, 40)
              .setColorBackground(#202020)
              .setColorForeground(#303030)
              .setCaptionLabel("Reset");
              
              //drawTimeStart();
              
              startColor = color(255, 0, 0); // Starting color (black)
              targetColor = color(0, 0, 255); // Target color (green)
              currentColor = startColor;
              
              rectangles = new Rect[50];
  
              for (int i = 0; i < rectangles.length; i++) {
              int x = (int) random(width - 25); // Random x position within the sketch width
              int y = (int) random(height - 25); // Random y position within the sketch height
              rectangles[i] = new Rect(x, y);
  }
              
}
  
 void draw() {
  background(#121212);

  // Update elapsed time only when not paused
  if (!isPaused) {
    elapsedTime = millis() - startTime;
  }
  
  noStroke();
  
  // creates the rectangles and makes them pulse
  if(!isPaused){
    for (int i = 0; i < rectangles.length; i++) {
    rectangles[i].display();
    rectangles[i].pulse();
    }
  }

  // Get the amplitude of the sound
  float amplitude = player.mix.level();

  // Update stroke color
  if (greenStroke) {
    currentColor = lerpColor(startColor, targetColor, sin(frameCount * transitionSpeed));
    stroke(currentColor);
  }

  // Calculate wave properties
  float waveHeight = amplitude * 300; // Adjust the multiplier to control the height of the wave
  float waveSpeed = map(sin(elapsedTime * 0.000000005), -1, 1, 0.01, 0.04);


  // Calculate the y-coordinate of the wave
  float offsetY = sin(frameCount * waveSpeed) * waveHeight;

  // Draw the waving line using curve
  float startX = -50;
  float startY = height / 2 + offsetY;
  float endX = width + 50;
  float endY = height / 2 + offsetY;
  int numPoints = 100; // Adjust this value to control the number of points

  noFill();
  beginShape();
  curveVertex(startX, startY);

  for (int i = 0; i < numPoints; i++) {
    float t = i / (float)(numPoints - 1);
    float x = lerp(startX, endX, t);
    float y = height / 2 + sin((frameCount * waveSpeed) + (t * TWO_PI)) * waveHeight;
    curveVertex(x, y);
  }

  curveVertex(endX, endY);
  endShape();

  drawTime();
  drawSongTitle();
}



void drawTime() {
  textAlign(CENTER, CENTER);
  
   // Update elapsed time only when not paused
  if (!isPaused) {
    elapsedTime = millis() - startTime;
  }
  
  int minutes = floor(elapsedTime / 60000);
  int seconds = floor((elapsedTime % 60000) / 1000);
  String timeStr = nf(minutes, 2) + ":" + nf(seconds, 2);
  fill(255);
  text(timeStr, 40, 20);
}

void drawTimeStart() {
  textAlign(CENTER, CENTER);
  fill(255);
  text("00:00", 40, 20);
}

void drawSongTitle() {
  textAlign(CENTER,CENTER);
  fill(255);
  String newFileName = player.getMetaData().fileName().replace(".mp3", "");
  text(newFileName, width/2, 20);
}

void playButton() {
  greenStroke = !greenStroke;
  isPaused = false;
  
  if (player.isPlaying()) {
    player.pause();
  } else {
    startTime = millis() - elapsedTime;
    player.play();
  }
}

void pauseButton() {
  player.pause();
  
  greenStroke = false;
  isPaused = true;
}

void resetButton() {
  startTime = millis();
  elapsedTime = 0;
  player.rewind();
}

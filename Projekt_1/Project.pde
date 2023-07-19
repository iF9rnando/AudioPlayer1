import ddf.minim.*;
import processing.sound.*;
int startTime;
int elapsedTime;

float circleRadius5 = 0; //Initial radius of the circle
float circleRadius4 = 0; //Initial radius of the circle
float circleRadius3 = 0; //Initial radius of the circle
float circleRadius2 = 0; //Initial radius of the circle
float circleRadiusMiddle = 0; //Initial radius of the circle
boolean greenStroke = false;
int numRectangles = 10; // Number of rectangles to create

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
              
              rectangles = new Rect[20];
  
  for (int i = 0; i < rectangles.length; i++) {
    int x = (int) random(width - 25); // Random x position within the sketch width
    int y = (int) random(height - 25); // Random y position within the sketch height
    rectangles[i] = new Rect(x, y);
  }
              
}

void draw() {
  //translate(width/2, height/2); 
  
  background(#121212);
  
  noStroke();
  
  if(!isPaused){
    for (int i = 0; i < rectangles.length; i++) {
    rectangles[i].display();
    rectangles[i].pulse();
  }
  }
  
  //drawRectangles();
  
  drawTime();
  
  // Update stroke color
  if (greenStroke) {
    currentColor = lerpColor(startColor, targetColor, sin(frameCount * transitionSpeed));
    stroke(currentColor);
  }
  
  // Set the stroke color
  stroke(currentColor);
  
  if(greenStroke == false){
    stroke(#303030);
  }
  
  // Get the amplitude of the sound
  float amplitude = player.mix.level();
  
  // Map the amplitude value to a desired range
  float circleSize3 = map(amplitude, 0, 1, 0, 200);
  float circleSize2 = map(amplitude, 0, 1, 0, 300);
  float circleSizeMiddle = map(amplitude, 0, 1, 0, 400);
  float circleSize4 = map(amplitude, 0, 1, 0, 100);
  float circleSize5 = map(amplitude, 0, 1, 0, 0);
  
  // Update the circle radius gradually
  float easing = 0.1;  // Controls the speed of animation
  circleRadius2 += (circleSize2 - circleRadius2) * easing;
  circleRadiusMiddle += (circleSizeMiddle - circleRadiusMiddle) * easing;
  circleRadius3 += (circleSize3 - circleRadius3) * easing;
  circleRadius4 += (circleSize4 - circleRadius4) * easing;
  circleRadius5 += (circleSize5 - circleRadius5) * easing;
  
  float array [] = {circleRadiusMiddle, circleRadius2, circleRadius3, circleRadius4, circleRadius5}; 
  
  strokeWeight(30); // Stroke weight
  
  // Set the roundness of the line endings
  strokeCap(ROUND); // Round line endings
  
  // Draw a line
  float x = 0;
  int i = 0;
  int y = 0;
  for(int index = 0; index <= 200; index = index + 50){
    line(width/2+x,200+y+array[i],width/2+x,600-y-array[i]);
    line(width/2-x,200+y+array[i],width/2-x,600-y-array[i]);
    x = x + 40;
    i = i + 1;
    y = y + 50;
  }
  
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
  // Play the audio file
  //player.play();
  // Toggle greenStroke variable
  greenStroke = !greenStroke;
  isPaused = false;
  
  if (player.isPlaying()) {
    // Pause the audio file
    player.pause();
  } else {
    // Start or resume playing the audio file
    startTime = millis() - elapsedTime;
    player.play();
  }
}

void pauseButton() {
  // Play the audio file
  player.pause();
  
  greenStroke = false;
  isPaused = true;
}

void resetButton() {
  // Play the audio file
  startTime = millis();
  elapsedTime = 0;
  player.rewind();
}

void createRandomRectangles() {
        for (int i = 0; i < numRectangles; i++) {
            float x = random(width); // Random x-coordinate within the window width
            float y = random(height); // Random y-coordinate within the window height

            // Generate random colors for the rectangles
            int fillColor = color(#202020);

            fill(fillColor);
            rect(x, y, 50, 50);
        }
    }

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
boolean paused;
int scale;
int r, g, b;
int centerX, centerY;

void setup() {
  size(600, 600);
  background(0);
  minim = new Minim(this);
  
  String file = "Synesthesia.mp3";
  song = minim.loadFile(file, 1024);
  song.play();
  
  beat = new BeatDetect();
  
  paused = false;
  scale = 100;
  r = 0;
  g = 0;
  b = 0;
  centerX = width/2;
  centerY = height/2;
}

void draw() {
  int t = millis();
  
  beat.detect(song.mix);
  if (beat.isOnset()) {
    r = Math.abs((int)(Math.cos(t + t/2) * 200));
    b = (int)(Math.abs(Math.sin(t + t/10)) * 255);
    g = Math.abs((int)(Math.tan(t + t/2) * 200));
    fill(r, g, b, 40);
    noStroke();
    rect(0, 0, width, height);
    
    strokeWeight(4);
    scale = 200;
  } else {
    fill(25, 40);
    noStroke();
    rect(0, 0, width, height);
    
    strokeWeight(2);
    scale = 100;
  }
  //strokeWeight(2);
  stroke(255);
  for (int i = 0; i < song.bufferSize() - 1; i++) {
   line(i, height/2 + song.mix.get(i)*scale,
       i+1, height/2 + song.mix.get(i+1)*scale);
  }
}

void keyPressed() {
  if(key == ' ') {
    if (!paused) {
      song.pause();
    } else {
      song.play();
    }
    paused = !paused;    
  }
  
  if (key == 'r') {
    song.rewind();
  }
  
  if (key == 'q') {
    exit();
  }
}
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
boolean paused;
FFT fft;
int scale;
int h, s, b;

void setup() {
  size(600, 600);
  pixelDensity(2);
  colorMode(HSB);
  noCursor();
  background(0);
  minim = new Minim(this);
  
  String file = "04 The Reeling.mp3";
  song = minim.loadFile(file);
  song.play();
  
  beat = new BeatDetect();
  
  fft = new FFT(song.bufferSize(), song.sampleRate());
  paused = false;
  scale = 70;
  h = 0;
  s = 255;
  b = 255;
}

void draw() {
  int t = millis();
  
  fft.forward(song.mix);
  
  strokeWeight(5);
  int c = 0;
  for (int i = 0; i < width; i++) {
    h = (int)map(i, 0, width, 0, 255);
    s = 150;
    b = 255;
    stroke(h, s, b);
    int n = (int)map(i, 0, width, 0, fft.specSize());
    float lineHeight = fft.getBand(n)*10;
    line(i, height, i, height - lineHeight);
  }
  
  beat.detect(song.mix);
  if (beat.isOnset()) {
   h = Math.abs((int)(Math.cos(t + t/2) * 200));
   s = 255;
   b = 255;
   fill(h, s, b, 40);
   noStroke();
   rect(0, 0, width, height);
    
   strokeWeight(4);
   scale = 100;
  } else {
   fill(25, 40);
   noStroke();
   rect(0, 0, width, height);
    
   strokeWeight(2);
   scale = 70;
  }
  stroke(255);
  for (int i = 0; i < song.bufferSize() - 1; i++) {
  line(i, height/2 + song.mix.get(i)*scale,
      i+1, height/2 + song.mix.get(i+1)*scale);
  }
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
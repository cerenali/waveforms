import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
AudioMetaData meta;
BeatDetect beat;
FFT fft;

PFont font;
String songTitle;
String songArtist;
String songLength;

boolean paused, showMeta;
int scale;
int h, s, b;

void setup() {
  smooth();
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
  
  meta = song.getMetaData();
  font = loadFont("Monospaced-11.vlw");
  textFont(font);
  songTitle = meta.title();
  songArtist = meta.author();
  songLength = parseLength(meta.length());
  
  showMeta = false;
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
  
  if (showMeta) {
    fill(255);
    textAlign(LEFT);
    text(songTitle, 10, 18);
    text(songArtist, 10, 33);
    text(songLength, 10, 48);
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
  
  if (key == 's') {
    saveFrame("waveforms-###.png");
  }
  
  if (key == 'q') {
    exit();
  }
}

void mousePressed() {
  showMeta = !showMeta;
}

String parseLength(int millis) {
  int minutes = (int)Math.floor(millis / 60000);
  int seconds = ((millis % 60000) / 1000);
  return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
}
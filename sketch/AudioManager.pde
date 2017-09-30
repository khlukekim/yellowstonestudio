
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

class AudioManager {

Minim minim;
FFT fft = null;
AudioPlayer song;
AudioInput mic;
BeatDetect beat;

boolean useSong = false;
boolean useMic = true;
boolean useBeat = true;

int lastBeatTime = 0;
int lastVirtualBeatTime = 0;
int sinceLastBeat = 100;
float estimatedBeatToBeat = 470;
boolean wasOnBeat = false;
boolean onBeat = false;
boolean onVirtualBeat = false;
boolean onAnyBeat = false;

public void init(boolean useSong, boolean useMic, boolean useBeat) {

  this.useSong = useSong;
  this.useMic = useMic;
  this.useBeat = useBeat;

  minim = new Minim(this);

  if (useSong) {
    song = minim.loadFile("song.mp3");
    song.play();
    fft = new FFT(song.bufferSize(), song.sampleRate());
  }
  if (useMic) {
    mic = minim.getLineIn();
    fft = new FFT(mic.bufferSize(), mic.sampleRate());
  }

  if (useBeat) {
    beat = new BeatDetect();
    beat.detectMode(BeatDetect.FREQ_ENERGY);
    lastBeatTime = millis();
    lastVirtualBeatTime = lastBeatTime;
  }
}

void getLevel(int bandFrom, int bandTo) {
  float level = 0;
  for(int i = bandFrom; i<bandTo; i++){
    level+=fft.getBand(i);
  }
  return level;
}

void processBeat() {
  if (fft == null) {
    println("Error: beat detection called without fft initialized.");
    return;
  }

  if (useSong) {
    fft.forward(song.mix);
    beat.detect(song.mix);
  } else if (useMic) {
    fft.forward(mic.mix);
    beat.detect(mic.mix);
  }

  int time = millis();
  onBeat = beat.isRange(18, 26, 5) && sinceLastBeat > 4;
  if (onBeat) {
    int beatDur = time - lastBeatTime;
    float nBeats = round(beatDur / estimatedBeatToBeat);
    if (nBeats > 0) {
      float newBTB = beatDur / nBeats;
      if (newBTB > 450 && newBTB < 510) {
        estimatedBeatToBeat = 0.9*estimatedBeatToBeat + 0.1*newBTB;
      }
    }
    println("Beat: " + beatDur);
    lastBeatTime = time;
    lastVirtualBeatTime = time;
    sinceLastBeat = 0;
  } else {
    if(time - lastVirtualBeatTime > estimatedBeatToBeat) {
      println("Virtual Beat: " + (time - lastVirtualBeatTime));
      lastVirtualBeatTime = time;
      onVirtualBeat = true;
    }else{
      onVirtualBeat = false;
    }

    sinceLastBeat += 1;
  }

  onAnyBeat = onBeat || onVirtualBeat;
}

public void getSpecSize() {
  return fft.specSize();
}
}
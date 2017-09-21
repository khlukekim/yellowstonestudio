var sketch = function( p ) {
  var bgImage;
  var ballImage;
  var r;
  var rings;
  var currentMode = 1;

  var dartboard;
  var drawer = null;

  var mic;

  function initMode(mode) {
    currentMode = mode;
    if (currentMode == 1) {
      drawer = new DartBoard(p, 10, 0.2 * p.height);
    } else if (currentMode == 2) {
      drawer = new Zap(p);
    }else if (currentMode == 3) {
      drawer = new Rossette(p);
    }else if (currentMode == 4) {
      drawer = new Crack(p);
    }else if (currentMode == 5) {
      drawer = new Spark(p);
    }
  }

  p.preload = function() {
    bgImage = p.loadImage("bg.jpg");
    ballImage = p.loadImage("star.jpg");
  };

  p.setup = function() {
    mic = new p5.AudioIn();
    mic.start();
    p.colorMode(p.HSB, 1);
    p.createCanvas(p.displayWidth, p.displayHeight);
    p.smooth();
    initMode(currentMode);
  };

  p.mousePressed = function() {
    drawer.mousePressed();
  };

  p.draw = function() {
    p.image(bgImage, 0, 0, p.width, p.height);
    var micLevel = mic.getLevel();
    //console.log(micLevel);
    if(drawer){
      drawer.draw(micLevel);
    }
  };

  p.keyPressed = function(){
    if(p.key == ' ') {
      var fs = p.fullscreen();
      p.fullscreen(!fs);
    }else if(p.key == '1') {
      initMode(1);
    }else if(p.key == '2') {
      initMode(2);
    }else if(p.key == '3') {
      initMode(3);
    }else if(p.key == '4') {
      initMode(4);
    }else if(p.key == '5') {
      initMode(5);
    }
  };

};

var myp = new p5(sketch);
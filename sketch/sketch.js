var sketch = function( p5 ) {
  var bgImage;
  var ballImage;
  var r;
  var rings;
  var currentMode = 4;

  var dartboard;
  var drawer = null;

  function initMode(mode) {
    currentMode = mode;
    if (currentMode == 1) {
      drawer = new DartBoard(p5, 10, 0.2 * p5.height);
    } else if (currentMode == 2) {
      drawer = new Zap(p5);
    }else if (currentMode == 3) {
      drawer = new Rossette(p5);
    }else if (currentMode == 4) {
      drawer = new Crack(p5);
    }else if (currentMode == 5) {
      drawer = new Spark(p5);
    }
  }

  p5.preload = function() {
    bgImage = p5.loadImage("bg.jpg");
    ballImage = p5.loadImage("star.jpg");
  };

  p5.setup = function() {
    p5.colorMode(p5.HSB, 1);
    p5.createCanvas(p5.displayWidth, p5.displayHeight);
    p5.smooth();
    initMode(5);
  };

  p5.mousePressed = function() {
    drawer.mousePressed();
  };

  p5.draw = function() {
    p5.image(bgImage, 0, 0, p5.width, p5.height);
    if(drawer){
      drawer.draw();
    }
  };

  p5.keyPressed = function(){
    if(p5.key == ' ') {
      var fs = p5.fullscreen();
      p5.fullscreen(!fs);
    }else if(p5.key == '1') {
      initMode(1);
    }else if(p5.key == '2') {
      initMode(2);
    }else if(p5.key == '3') {
      initMode(3);
    }else if(p5.key == '4') {
      initMode(4);
    }else if(p5.key == '5') {
      initMode(5);
    }
  };

};

var myp5 = new p5(sketch);
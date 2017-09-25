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
      p.clear();
      drawer = new Particles(p);
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
    var canvas = p.createCanvas(p.displayWidth, p.displayHeight);
    canvas.parent('container');
    p.smooth();
    initMode(currentMode);
    var b = document.getElementById('bg');
    b.style.width = p.displayWidth;
    b.style.height = p.displayHeight;
  };

  p.mousePressed = function() {
    drawer.mousePressed();
  };

  p.draw = function() {
    //console.log(p.frameRate());
    //p.image(bgImage, 0, 0, p.width, p.height);
    if (currentMode != 5) {
      p.clear();
    }
    var micLevel = mic.getLevel();
    //console.log(micLevel);
    if(drawer){
      drawer.draw(micLevel);
    }
  };

  p.keyPressed = function(){
    if(p.key == ' ') {
      var elem = document.getElementById("container");
      if (elem.requestFullscreen) {
        elem.requestFullscreen();
      } else if (elem.mozRequestFullScreen) {
        elem.mozRequestFullScreen();
      } else if (elem.webkitRequestFullscreen) {
        elem.webkitRequestFullscreen();
      }
      p.fullscreen(!fs);
    }else if(p.key == '1' || p.key == 'q' || p.key == 'Q') {
      initMode(1);
    }else if(p.key == '2' || p.key == 'w' || p.key == 'W') {
      initMode(2);
    }else if(p.key == '3' || p.key == 'e' || p.key == 'E') {
      initMode(3);
    }else if(p.key == '4' || p.key == 'r' || p.key == 'R') {
      initMode(4);
    }else if(p.key == '5' || p.key == 't' || p.key == 'T') {
      initMode(5);
    }
  };

};

var myp = new p5(sketch);
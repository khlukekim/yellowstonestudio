var sketch = function( p5 ) {
  var bgImage;

  p5.preload = function() {
    bgImage = p5.loadImage("bg.jpg");
  };

  p5.setup = function() {
    p5.createCanvas(p5.displayWidth, p5.displayHeight);
    p5.image(bgImage, 0, 0, p5.displayWidth, p5.displayHeight);
  }
  p5.mousePressed = function() {
    var fs = p5.fullscreen();
    p5.fullscreen(!fs);
  }
};

var myp5 = new p5(sketch);
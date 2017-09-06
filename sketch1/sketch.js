var sketch = function( p5 ) {
  var bgImage;

  var t = new Array(12);
  var k = 9;



  var begin = function(R, r, n){
    p5.strokeWeight(5);
    p5.stroke(255);
    p5.translate(p5.width/2, p5.height/2);
    for (var i = 0; i <= n; i= i+1) {
      t[i] = 2*i*p5.PI/n-p5.PI/4;
      if (i % 2 == 0) {
        p5.arc(0, 0, 2*R, 2*R, t[i], t[i+1]);
      } else {
        p5.arc(0, 0, 2*r, 2*r, t[i], t[i+1]);
      }
    }
  };

  p5.preload = function() {
    bgImage = p5.loadImage("bg.jpg");
  };

  p5.setup = function() {
    p5.createCanvas(p5.displayWidth, p5.displayHeight);
  };

  p5.mousePressed = function() {
    var fs = p5.fullscreen();
    p5.fullscreen(!fs);
  };

  p5.draw = function() {
    p5.image(bgImage, 0, 0, p5.displayWidth, p5.displayHeight);
    p5.noFill();
    begin(50*p5.abs(p5.cos(k)) +100, 50*p5.abs(p5.sin(k)) +100, 12);
    k = k + p5.PI/128;
  };

};

var myp5 = new p5(sketch);
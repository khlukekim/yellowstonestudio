function Spark(p5){
  this.p5 = p5;
  this.ss = [];
  for(var i = 0; i<12; i++) {
    this.ss.push(new Sparkling(p5, p5.random(p5.width), p5.random(p5.height)));
  }
}

Spark.prototype.draw = function() {
  for(var i = 0; i< 12; i++) {
    this.ss[i].draw();
  }

  if(this.p5.random() > 0.9) {
    this.ss.splice(0, 1);
    this.ss.push(new Sparkling(this.p5, this.p5.random(this.p5.width), this.p5.random(this.p5.height)));
  }
}

function Sparkling(p5, x,y) {
  this.p5 = p5;
  this.x = x;
  this.y = y;
}

Sparkling.prototype.draw = function(){

  var pa = this.p5;
  var x = this.x;
  var y = this.y;
    pa.push();
    for (var i = 0; i < 10; i++) {
      pa.stroke(2, 0.5);
      var theta = pa.random(1.95*pa.PI);
      var  rad = pa.random (35, 120);
      var x1 = x + pa.sin(theta)*rad;
      var y1 = y + pa.cos(theta)*rad;
      pa.line(x, y, x1, y1);

      for (var j = 0; j < 5; j++) {
        pa.stroke(1, 0.7, 1);
        var x2 = pa.random(-2, 2);
        var y2 = pa.random(-2, 2);
        pa.line(x1, y1, x1 + x2, y1 + y2);
      }
    }
    pa.pop();

}
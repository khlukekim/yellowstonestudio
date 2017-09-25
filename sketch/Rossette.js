function Rossette(p5) {
  this.p5 = p5;

  this.ang=0;
  this.ang2=0;
  this.ss = this.p5.random(2,5);
  this.c = [];
  this.makeColors();
}


Rossette.prototype.draw = function(m) {
  var pa = this.p5;
  pa.push();
  //background(0,0,90);
  pa.translate(pa.width/2, pa.height/2);
  for(var iter=0;iter<160;iter++) {
    pa.push();
    // rotate 360 degrees and
    pa.rotate(this.ang+this.ang2/2.0);
    for(var i=0;i<3;i++) {
      pa.fill(this.c[i],(20+i*30)/255.);
      // draw vertical rectangle with start and end point based on noise
      pa.rect(0,-(i+1)*10-30*pa.noise(this.ang2+pa.cos(-this.ang+i)*2),10,-100-(50+(5-i)*40)*pa.noise(pa.sin(this.ang+i)*this.ss+i/2,this.ang2));
    }
    pa.pop();
    this.ang+=pa.TWO_PI/160.0;
  }
  pa.pop();
  this.ang2+=pa.TWO_PI/300 * (1 + 4*m);
  this.ang=0.0;
};


Rossette.prototype.makeColors = function() {
    this.c = [];
    var h = this.p5.random(1);
    var s = this.p5.random(0.5,0.7);
    var b = this.p5.random(0.7,0.9);
    this.c[0] = this.p5.color(h,s,b);
    this.c[1] = this.p5.color( h-(0.07+this.p5.random(-0.015,0.015)),s,b);
    this.c[2] = this.p5.color( h+(0.07+this.p5.random(-0.015,0.015)),s,b);
    this.c[4] = this.p5.color(h,s*0.6,b*0.6);
    this.c[3] = this.p5.color( h+0.5+this.p5.random(-0.015,0.015),s,b*0.9);
  }

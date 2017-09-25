
function Crack(p5){
  this.p5 = p5;
  this.t = [];
  for(var i = 0; i<12; i++) {
    this.t.push(0);
  }
  this.k = 9;
}


Crack.prototype.draw = function(m){
  var pa = this.p5;
  pa.push();
  pa.noFill();
  this.begin(50*pa.abs(pa.cos(this.k)) +100, 50*pa.abs(pa.sin(this.k)) +100, 12);
  this.k = this.k + (pa.PI/200) * (1 + 3*m);
  pa.pop();
};

Crack.prototype.begin = function(R, r, n){
  var pa = this.p5;
    pa.strokeWeight(5);
    pa.stroke(1);
    pa.translate(pa.width/2, pa.height/2);
    for (var i = 0; i <= n; i= i+1) {
      this.t[i] = 2*i*pa.PI/n-pa.PI/4;
      if (i % 2 == 0) {
        pa.arc(0, 0, 2*R, 2*R, this.t[i], this.t[i+1]);
      } else {
        pa.arc(0, 0, 2*r, 2*r, this.t[i], this.t[i+1]);
      }
    }
  };

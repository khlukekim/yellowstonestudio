function Particles(p) {
  this.p = p;
  this.particles = [];
  this.n = 400;
  for (var i = 0; i < this.n; i++) {
    this.particles.push(new Particle(this.p));
  }
}

Particles.prototype.draw = function(level) {
  this.p.loadPixels();
  var d = this.p.pixelDensity();


  for (var m = 0; m< level * 800; m++) {
    var k = parseInt(Math.random() * this.n);
    for (var i = 0; i < d; i++) {
      for (var j = 0; j < d; j++) {
        var particle = this.particles[k];
        var idx = 4 * ((parseInt(particle.y) * d + j) * this.p.width * d + (parseInt(particle.x) * d + i));
        this.p.pixels[idx+3] *= 0.6;
        //particle.setSpeed(level * 10);
        particle.update();
        idx = 4 * ((parseInt(particle.y) * d + j) * this.p.width * d + (parseInt(particle.x) * d + i));
        this.p.pixels[idx] = this.p.red(particle.c);
        this.p.pixels[idx+1] = this.p.green(particle.c);
        this.p.pixels[idx+2] = this.p.blue(particle.c);
        this.p.pixels[idx+3] = 255;//this.p.alpha(particle.c);
      }
    }
  }
  this.p.updatePixels();
};


function Particle(p) {
  this.p = p;
  this.particleRadius = p.height * 0.35;
  var a = p.random(2*p.PI);
  var r = p.random(this.particleRadius);
  this.x = p.width / 2 + r * p.cos(a);
  this.y = p.height / 2 + r * p.sin(a);
  this.ang = p.random(2 * p.PI);
  this.v = 0.8;
  this.vx = this.v * p.sin(this.ang);
  this.vy = this.v * p.cos(this.ang);
  p.push();
  p.colorMode(p.HSB, 1);
  this.c = p.color(0 + (p.random(1)), 0.6 + p.random(0.2), 0.8 + p.random(0.2));
  p.pop();
}

Particle.prototype.setSpeed = function(s) {
  this.v = s;
  this.vx = this.v * this.p.cos(this.ang);
  this.vy = this.v * this.p.sin(this.ang);
};

Particle.prototype.relocate = function() {
  var a = this.p.random(2 * this.p.PI);
  var r = this.p.random(this.particleRadius);
};

Particle.prototype.update = function() {
  this.x += this.vx;
  this.y += this.vy;
  var dx = this.p.width / 2 - this.x;
  var dy = this.p.height / 2 - this.y;
  if (this.p.sqrt((dx * dx) + (dy * dy)) > this.particleRadius) {
    this.ang = this.p.atan2(dy, dx) / this.p.PI * 180;
    this.setSpeed(this.v);
  }
};

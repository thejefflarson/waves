const detail = 256;

function Renderer() {
  this.gl = GL.create({antialias: true});
  this.time = 0;
  this.mesh = GL.Mesh.plane({ coords: true, detailX: detail/2 - 1, detailY: detail/2 - 1 });
  this.mesh.computeWireframe();
  this.displacement = new GL.Texture(detail, detail, { type: this.gl.FLOAT });
  load(
    'javascripts/shaders/displacement.fragment.glsl',
    'javascripts/shaders/fullscreen.vertex.glsl',
    'javascripts/shaders/peek.fragment.glsl',
    'javascripts/shaders/peek.vertex.glsl',
    this.go.bind(this)
  );
}

Renderer.prototype = {
  go : function(shaders) {
    this.displace = new GL.Shader(
      shaders['javascripts/shaders/fullscreen.vertex.glsl'],
      shaders['javascripts/shaders/displacement.fragment.glsl']
    );
    this.peek = new GL.Shader(
      shaders['javascripts/shaders/peek.vertex.glsl'],
      shaders['javascripts/shaders/peek.fragment.glsl']
    );
    this.gl.ondraw = this.draw.bind(this);
    this.gl.onupdate = this.update.bind(this);

    this.gl.fullscreen({camera:false});
    this.gl.animate();
  },

  update : function(seconds) {
    this.time += seconds / 2;
  },

  draw : function() {
    var gl = this.gl;
    gl.enable(gl.DEPTH_TEST);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    // gl.matrixMode(gl.PROJECTION);
    // gl.loadIdentity();
    // gl.perspective(45, gl.canvas.width / gl.canvas.height, 0.1, 1000);
    // gl.translate(0, 0, -5);
    // gl.rotate(-45, 1, 0, 0);
    // gl.rotate(60, 0, 0, 1);

    var wind = [20.0, 200.0];
    // var a = [];
    // a[0] = Math.cos(this.time) * wind[0] - Math.sin(this.time) * wind[1];
    // a[1] = Math.sin(this.time) * wind[0] + Math.cos(this.time) * wind[1];
    // wind = a;

    this.displacement.drawTo(function(){
      gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
      gl.loadIdentity();
      this.displace.uniforms({
        time: this.time,
        size: 100,
        res: detail,
        depth: 100,
        wind: wind
      }).draw(this.mesh);
    }.bind(this));
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);


    gl.matrixMode(gl.PROJECTION);
    gl.loadIdentity();
    gl.perspective(45, gl.canvas.width / gl.canvas.height, 0.1, 1000);
    gl.translate(0, 0, -5);
    gl.rotate(-45, 1, 0, 0);
    gl.rotate(60, 0, 0, 1);

    this.displacement.bind(0);
    this.peek.uniforms({
      color: 0
    }).draw(this.mesh);
    this.displacement.unbind();
  }
};

var renderer = new Renderer();
const detail = 512;

function Renderer() {
  this.gl = GL.create({antialias: true});
  this.time = 0;
  this.mesh = GL.Mesh.plane({ coords: true });
  this.mesh.computeWireframe();
  this.displacement = new GL.Texture(detail, detail, {type: this.gl.FLOAT, minFilter: this.gl.NEAREST, magFilter: this.gl.NEAREST });
  load(
    'javascripts/shaders/displacement.fragment.glsl',
    'javascripts/shaders/fullscreen.vertex.glsl',
    'javascripts/shaders/peek.fragment.glsl',
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
      shaders['javascripts/shaders/fullscreen.vertex.glsl'],
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

    this.displacement.drawTo(function(){
      gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
      gl.loadIdentity();
      this.displace.uniforms({
        time: this.time,
        size: 250,
        res: detail,
        depth: 100,
        wind: [50.0, 10.0]
      }).draw(this.mesh);
    }.bind(this));
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    this.displacement.bind(0);
    this.peek.uniforms({
      color: 0
    }).draw(this.mesh);
    this.displacement.unbind();
  }
};

var renderer = new Renderer();
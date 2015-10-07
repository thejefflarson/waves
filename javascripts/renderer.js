const detail = 256;

function Renderer() {
  this.gl = GL.create({antialias: true});
  this.time = 0;
  this.mesh = GL.Mesh.plane({ coords: true });
  this.mesh.computeWireframe();
  this.displacement = new GL.Texture(detail, detail, {type: this.gl.FLOAT, minFilter: this.gl.NEAREST, magFilter: this.gl.NEAREST });
  load(
    'javascripts/shaders/displacement.fragment.glsl',
    'javascripts/shaders/displacement.vertex.glsl',
    this.go.bind(this)
  );
}

Renderer.prototype = {
  go : function(shaders) {
    this.display = new GL.Shader(
      shaders['javascripts/shaders/displacement.vertex.glsl'],
      shaders['javascripts/shaders/displacement.fragment.glsl']
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

    this.display.uniforms({
      time: this.time,
      size: 250,
      res: detail,
      depth: 10,
      wind: [100.0, 100.0]
    }).draw(this.mesh);
  }
};

var renderer = new Renderer();
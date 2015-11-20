const detail = 512;
const size = 500;

function Renderer() {
  this.gl = GL.create({antialias: true});
  this.time = 100;
  this.mesh = GL.Mesh.plane({ coords: true, detailX: detail/4 - 1, detailY: detail/4 - 1 });
  this.mesh.transform(GL.Matrix.scale(size, size, 0));
  this.mesh.computeWireframe();
  this.numWaves = 100;
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
  gauss : function(){
    var u1, u2, v1, v2, s;
    var mean = 0.0;
    var stdev = 0.75;
    if (this.v2 === null) {
      do {
        u1 = Math.random();
        u2 = Math.random();

        v1 = 2 * u1 - 1;
        v2 = 2 * u2 - 1;
        s = v1 * v1 + v2 * v2;
      } while (s === 0 || s >= 1);

      this.v2 = v2 * Math.sqrt(-2 * Math.log(s) / s);
      return stdev * v1 * Math.sqrt(-2 * Math.log(s) / s) + mean;
    }

    v2 = this.v2;
    this.v2 = null;
    return stdev * v2 + mean;
  },
  v2 : null,

  go : function(shaders) {
    this.displace = new GL.Shader(
      shaders['javascripts/shaders/fullscreen.vertex.glsl'],
      shaders['javascripts/shaders/displacement.fragment.glsl'].replace('<%= numWaves %>', this.numWaves)
    );
    this.peek = new GL.Shader(
      shaders['javascripts/shaders/peek.vertex.glsl'],
      shaders['javascripts/shaders/peek.fragment.glsl']
    );

    // really random values
    var data = new Float32Array(this.numWaves * 3);
    for(var i = 0; i < this.numWaves * 3; i += 3)
      data[i] = this.gauss();

    this.rand = new GL.Texture(this.numWaves, 1, {format: this.gl.RGB, type: this.gl.FLOAT});
    this.gl.texImage2D(this.gl.TEXTURE_2D, 0, this.rand.format, this.numWaves, 1, 0, this.rand.format, this.rand.type, data);

    this.gl.ondraw = this.draw.bind(this);
    this.gl.onupdate = this.update.bind(this);

    this.gl.fullscreen({camera:false, antialias:true});
    this.gl.animate();
  },

  update : function(seconds) {
    this.time += seconds;
  },

  draw : function() {
    var gl = this.gl;
    gl.enable(gl.DEPTH_TEST);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    var wind = [30.0, 30.0];

    this.displacement.drawTo(function(){
      gl.viewport(0, 0, detail, detail);
      gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
      gl.loadIdentity();
      this.rand.bind(0);
      this.displace.uniforms({
        time: this.time,
        size: size,
        res: detail,
        wind: wind,
        rnd: 0
      }).draw(this.mesh);
      this.rand.unbind(0);
    }.bind(this));
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    gl.matrixMode(gl.PROJECTION);
    gl.loadIdentity();
    gl.perspective(45, gl.canvas.width / gl.canvas.height, 1, 900000);

    gl.matrixMode(gl.MODELVIEW);
    gl.loadIdentity();
    gl.translate(0, 0, -5 * size);
    gl.rotate(-45, 1, 0, 0);
    gl.rotate(60, 0, 0, 1);

    this.displacement.bind(0);
    this.peek.uniforms({
      color: 0,
      size: size,
      res: detail
    }).draw(this.mesh);
    this.displacement.unbind();
  }
};

var renderer = new Renderer();
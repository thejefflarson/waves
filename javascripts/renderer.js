// 'use strict';

const detail = 128 * 2;

function Renderer() {
  this.gl = GL.create({antialias: true});
  this.time = 0;
  this.mesh = GL.Mesh.plane({ coords: true, detailX: detail - 1, detailY: detail - 1 });
  this.mesh.computeWireframe();
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
    gl.enable(gl.CULL_FACE);
    gl.enable(gl.DEPTH_TEST);
    gl.enable(gl.BLEND);
    gl.blendFunc(this.gl.SRC_ALPHA, this.gl.ONE_MINUS_SRC_ALPHA);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    gl.matrixMode(gl.PROJECTION);
    gl.loadIdentity();
    gl.perspective(45, gl.canvas.width / gl.canvas.height, 0.1, 1000);
    gl.translate(0, 0, -2);
    gl.rotate(-45, 1, 0, 0);
    gl.rotate(60, 0, 0, 1);

    this.display.uniforms({
      time: this.time
    }).draw(this.mesh, gl.LINES);
  }
};

var renderer = new Renderer();
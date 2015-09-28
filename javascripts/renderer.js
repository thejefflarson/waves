'use strict';

const detail = 128;

class Renderer {
  constructor() {
    this.gl = GL.create({antialias: true});
    this.time = 0;
    this.mesh  = GL.Mesh.plane({ coords: true, detailX: detail, detailY: detail });
    this.plane = GL.Mesh.plane({ coords: true });
    this.mesh.computeWireframe();
    load(
      'javascripts/shaders/displacement.fragment.glsl',
      'javascripts/shaders/display.fragment.glsl',
      'javascripts/shaders/display.vertex.glsl',
      'javascripts/shaders/plane.vertex.glsl',
      this.go.bind(this)
    );
    this.displace = new GL.Texture(detail * 2, detail * 2, {type: this.gl.FLOAT, magFilter: this.gl.NEAREST});
  }

  go(shaders) {
    this.createDisplacement = new GL.Shader(
      shaders['javascripts/shaders/plane.vertex.glsl'],
      shaders['javascripts/shaders/displacement.fragment.glsl']
    );
    this.display = new GL.Shader(
      shaders['javascripts/shaders/display.vertex.glsl'],
      shaders['javascripts/shaders/display.fragment.glsl']
    );
    this.gl.ondraw = this.draw.bind(this);
    this.gl.onupdate = this.update.bind(this);

    this.gl.fullscreen({camera:false});
    this.gl.animate();
  }

  update(seconds) {
    this.time += seconds;
  }

  draw() {
    var gl = this.gl;
    gl.enable(gl.CULL_FACE);
    gl.enable(gl.DEPTH_TEST);
    gl.enable(gl.BLEND);
    gl.blendFunc(this.gl.SRC_ALPHA, this.gl.ONE_MINUS_SRC_ALPHA);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    gl.matrixMode(gl.PROJECTION);
    gl.loadIdentity();
    gl.perspective(45, gl.canvas.width / gl.canvas.height, 0.1, 1000);
    gl.translate(0, 0, -5);
    gl.rotate(-45, 1, 0, 0);
    gl.rotate(60, 0, 0, 1);

    this.displace.drawTo(() => {
      this.createDisplacement.uniforms({
        time: this.time
      }).draw(this.plane);
    });

    this.displace.bind(0);
    this.display.uniforms({
      tex: 0
    }).draw(this.mesh);
    this.displace.unbind();
  }
}

var renderer = new Renderer();
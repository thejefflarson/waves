uniform sampler2D color;
varying vec3 coord;

void main(){
  gl_FragColor = vec4(0., 0., coord.z * 10., 1.);
}
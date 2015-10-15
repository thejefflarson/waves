uniform sampler2D color;
varying vec2 coord;

void main(){
  gl_FragColor = texture2D(color, vec2(coord));
}
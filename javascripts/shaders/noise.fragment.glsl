varying vec2 coord;

void main(){
  float rand = fract(sin(dot(coord.xy, vec2(12.9898,78.233))) * 43758.5453);
  gl_FragColor = vec4(rand);
}
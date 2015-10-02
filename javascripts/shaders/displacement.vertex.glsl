uniform float time;
varying float height;

float h(float freq, float w) {
  float w_0 = 9.8 / w;
  return sqrt(0.0081 * 9.81 * 9.81 / pow(freq, 5.) * exp(0.74 * pow(w_0 / freq, 4.)));
}

float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
  vec2 xy_0 = gl_Vertex.xy; // 256 x 256 grid
  vec2 xy = xy_0;
  vec2 wind = vec2(0.5, 0.5);
  int numWaves = 60;
  // for sampling the angles
  float gauss[5];
  gauss[0] = 0.7486141966030053;
  gauss[1] = 0.2430394460266544;
  gauss[2] = 0.008316352518541832;
  gauss[3] = 0.00002999345041948455;
  gauss[4] = 0.00000001140137905086809;

  for(int i = 0; i < numWaves; i++) {
    float x = float(i) / (float(numWaves) - 1.);
    float lambda = pow(2., (1. - x) * 0.02 + x * 30.0);


  }
  gl_Position = gl_ModelViewProjectionMatrix * vec4(xy, height, gl_Vertex.w);
}

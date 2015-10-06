uniform float time;
varying float height;

const vec2 K(0.0, 0.5); // wind
const float g = 9.81;   // gravity m / s ^2
const float h = 100.0;  // depth of the water
const float o = 0.074;  // surface tension
const float p = 1000;   // density of water
const float U = 100;    // average wind speed

float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float jonswap(float freq) {
  float k = length(K);
  float omega = sqrt((g * k + o / p * pow(k, 3.0)) * tanh(k * h));
  float omega_p =
  return 1.;
}


void main() {
  vec2 xy_0 = gl_Vertex.xy; // 256 x 256 grid
  vec2 xy = xy_0;
  vec2 wind = vec2(0.5, 0.5);
  const int numWaves = 60;
  // for sampling the angles
  float gauss[5];
  gauss[0] = 0.7486141966030053;
  gauss[1] = 0.2430394460266544;
  gauss[2] = 0.0083163525185418;
  gauss[3] = 0.0000299934504194;
  gauss[4] = 0.0000000114013790;

  for(int i = 0; i < numWaves; i++) {
    float x = float(i) / (float(numWaves) - 1.);
    float lambda = pow(2., (1. - x) * 0.02 + x * 30.0);


  }
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}

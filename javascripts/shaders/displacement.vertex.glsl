uniform float time;
varying float height;

const float g = 9.81;    // gravity m / s ^2
const float h = 100.0;   // depth of the water
const float p = 1000.;   // density of water
const float U = 100.;    // average wind speed
const float F = 50000.;  // fetch
const float y = 3.3;     // gamma for JONSWAP
const float e = 2.71828; // e

float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float tanh(float x) {
  float e_x = pow(e, x);
  float e_ix = pow(e, -x);
  return (e_x - e_ix) / (e_x + e_ix);
}

float jonswap(vec2 wind) {
  float k = length(wind);
  float omega = sqrt((g * k + 0.074 / p * pow(k, 3.0)) * tanh(k * h));
  float omega_p = 22.0 * pow(g, 2.0) / (U * F); // peak frequency
  float sigma = omega <= omega_p ? 0.07 : 0.09;
  float alpha = 0.076 * pow(pow(U, 2.0) / (F * g), 0.22);
  float r = exp(-1.0 * pow((omega - omega_p), 2.0) /
            (2.0 * pow(sigma, 2.0) * pow(omega_p, 2.0)));
  float s = alpha * pow(g, 2.0) / pow(omega, 5.0) * exp(-5. / 4. * pow(omega_p / omega, 4.0)) * pow(y, r);
  return s;
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
  gl_Position = gl_ModelViewProjectionMatrix * vec4(gl_Vertex.xy, -jonswap(gl_Vertex.xy), gl_Vertex.w);
}

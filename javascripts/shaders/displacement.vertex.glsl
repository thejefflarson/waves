uniform float time;
varying float height;

const float g  = 9.81;    // gravity m / s ^2
const float h  = 50.;    // depth of the water
const float p  = 1000.;   // density of water
const float F  = 50.;  // fetch
const float y  = 3.3;     // gamma for JONSWAP
const float e  = 2.71828; // e
const float pi = 3.14159; // pi, du

float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float rand(float num) {
  return rand(vec2(num));
}

float tanh(float x) {
  float e_x = pow(e, x);
  float e_ix = pow(e, -x);
  return (e_x - e_ix) / (e_x + e_ix);
}

// corrects for depth of the ocean
float kitai(float w, float depth) {
  float w_h = w * sqrt(depth / g);
  return smoothstep(0., 2.2, w_h);
}

// frequency of ocean waves
float jonswap(float w, float U) {
  float w_p = 22. * pow(g, 2.) / (U * F); // peak frequency
  float sigma = w <= w_p ? 0.07 : 0.09;
  float alpha = 0.076 * pow(pow(U, 2.) / (F * g), 0.22);
  float r = exp(-1. * pow((w - w_p), 2.) /
            (2. * pow(sigma, 2.) * pow(w_p, 2.)));
  float s = alpha * pow(g, 2.) / pow(w, 5.) * exp(-5. / 4. * pow(w_p / w, 4.)) * pow(y, r);
  return s;
}

float omega(float k, float depth) {
  return sqrt((g * k + 0.074 / p * pow(k, 3.)) * tanh(k * depth));
}

// from http://www.dtic.mil/dtic/tr/fulltext/u2/a157975.pdf via Horvath
float tma(vec2 K, vec2 wind, float depth) {
  float k = length(K); // wave vector
  float U = length(wind); // wind speed
  float w = omega(k, depth);
  float theta = atan(wind.y / wind.x);
  // we use tessendorf's spreading function because it is easier
  float d = theta > -pi / 2. && theta < pi / 2. ? 2. / pi * pow(cos(theta), 2.) : 0.;
  return jonswap(w, U) * kitai(w, depth) * d;
}

void main() {
  vec2 wind = vec2(20.5, 100.0);
  const int numWaves = 40;
  float seed = rand(gl_Vertex.xy);
  float z = 0.;
  for(int i = 0; i < numWaves; i++) {
    vec2 K;
    float theta = atan(wind.y / wind.x);
    seed = rand(seed);
    K.x = seed;
    seed = rand(seed);
    K.y = seed;
    float x = K.x;
    // guassian transform
    K.x = sqrt(-2. * log(K.x) / log(e) * cos(2. * pi * K.y)) * cos(theta);
    K.y = sqrt(-2. * log(x) / log(e) * sin(2. * pi * K.y)) * sin(theta);
    float a = sqrt(tma(K, wind, h)) / 2.;
    float k = length(K);
    z += a * cos(omega(k, h) * time - dot(K, gl_Vertex.xy * 40.));
  }
  z = z / float(numWaves);
  height = abs(z);
  gl_Position = gl_ModelViewProjectionMatrix * vec4(gl_Vertex.xy, z, gl_Vertex.w);
}

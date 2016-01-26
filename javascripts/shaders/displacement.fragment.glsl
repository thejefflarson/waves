uniform float res;
uniform float size;
uniform float time;
uniform sampler2D rnd;
uniform sampler2D height;
varying vec2 coord;

const float g  = 9.81;    // gravity m / s ^2
const float e  = 2.71828; // e, duh
const float pi = 3.14159; // pi, duh
const float depth = 10.;
const int numWaves = <%= numWaves %>;

float rand(int x) {
  return texture2D(rnd, vec2((float(x) + 0.5) / float(numWaves), 1.)).r;
}

float tanh(float x) {
  return (1.0 - exp(-2.0 * x)) / (1.0 + exp(-2.0 * x));
}

vec2 unpack_wind(const vec4 data) {
  float min = -38.076587;
  float max = 40.227959;
  float x = data.r * (max - min) + min;
  float y = data.a * (max - min) + min;
  return vec2(x, y);
}

void main(){
  vec2 c = (gl_FragCoord.xy / res - 0.5) * size;
  vec2 d = (gl_FragCoord.xy / res) / 2.;
  // d.y += 0.5;
  // d.x += 0.5;
  vec2 wind = unpack_wind(texture2D(height, d));
  vec4 b = vec4(0.);

  float mn = log(0.02) / log(2.0);
  float mx = log(length(wind)) / log(2.0);
  float wtheta = atan(wind.x, wind.y);
  mat2 windRot = mat2(cos(wtheta), sin(wtheta), -sin(wtheta), cos(wtheta));

  for(int i = 0; i < numWaves; i++) {
    float x = float(i) / (float(numWaves) - 1.);
    float lambda = pow(2.0, (1.0 - x) * mn + x * mx);
    float theta  = rand(i);
    float knorm  = 2. * pi / lambda;
    float omega  = sqrt(g * knorm * tanh(knorm * depth));
    vec2 K = vec2(knorm * cos(theta), knorm * sin(theta));
    float s = 0.0081 * g * g / pow(omega, 5.) * exp(-1. * 5. / 4. * pow((0.855 * g) / length(wind) / omega, 4.));
    float a = sqrt(s);
    // filter out small wavelengths
    float wp = smoothstep(0.1, 1.5, 2.0 * pi * g / omega * omega * res / size);
    float arg = omega * time - dot(K, windRot * c.xy);
    b.z  += wp * a * cos(arg);
    b.xy += wp * a * normalize(K) * sin(arg);
  }

  gl_FragColor = b;
}


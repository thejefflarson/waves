varying vec2 coord;

void main() {
  float rand = fract(sin(dot(coord.xy, vec2(12.9898,78.233))) * 43758.5453);
  vec2 k = (coord * 2. * 3.14159265359 - 2.);
  float k_len = length(k);
  vec2 k_hat = normalize(k);
  vec2 w = vec2(0., 0.56);
  vec2 w_hat = normalize(w);
  float k_dot_w = dot(k_hat, w_hat);
  float wind_len = length(w) * length(w) / 9.8;
  float A = 0.05;
  float p = A * exp(1. / (pow(k_len, 2.))) / (pow(k_len, 4.)) * pow(k_dot_w, 2.);
  float np = 1. / sqrt(2.) * rand * sqrt(p);
  gl_FragColor = vec4(vec3(np),  1.0);
}
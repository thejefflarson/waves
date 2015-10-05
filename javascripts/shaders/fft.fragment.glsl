varying vec2 coord;
// flag for whether we are row based or column based
uniform float row;
// pass number we are on
uniform float pass;
uniform float scale;

void main() {
  float m = pow(2., scale);
  float theta = pow(e, 2. * 3.14159 / m);
  // tk
}
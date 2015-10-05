varying vec2 coord;
uniform float time;
uniform vec2 wind; // average wind speed

// from http://dutch360hdr.com/downloads/other/EmpiricalDirectionalWaveSpectra_DigiPro2015_Jun20_2015.pdf

float jonswap(float w) { // eq. 28
  float U  = length(wind);
  float F  = 50000; // fetch -- distance to the shore in kilometers
  float sigma;
  float wp = 22.0 * pow(9.8, 2.0) / (U * F);

  if(w <= wp) {
    sigma = 0.07;
  } else {
    sigma = 0.09;
  }

  float r  = exp(pow(-1.0 * w - wp, 2.0) / (2.0 * ))
}

void main() {
  gl_FragColor = vec4(p * exp(e), ip * exp(e), 1., 1.);
}
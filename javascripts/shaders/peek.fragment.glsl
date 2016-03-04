uniform sampler2D color;
uniform float res;
uniform float size;
varying vec4 position;
varying vec3 coord;
varying float height;

vec3 hdr (vec3 color, float exposure) {
  return 1.0 - exp(-color * exposure);
}

vec3 getpos(vec2 coord) {
  return texture2D(color, coord).rgb;
}

vec3 getnormal(vec2 coord) {
  float texel = 1. / res;
  float texelSize = size / res;
  vec3 center = texture2D(color, coord).rgb;
  vec3 right  = vec3(texelSize, 0.0, 0.0) +  getpos(coord + vec2(texel, 0.0)) - center;
  vec3 left   = vec3(-texelSize, 0.0, 0.0) + getpos(coord + vec2(-texel, 0.0)) - center;
  vec3 top    = vec3(0.0, 0.0, -texelSize) + getpos(coord + vec2(0.0, -texel)) - center;
  vec3 bottom = vec3(0.0, 0.0, texelSize) +  getpos(coord + vec2(0.0, texel)) - center;

  vec3 topRight = cross(right, top);
  vec3 topLeft = cross(top, left);
  vec3 bottomLeft = cross(left, bottom);
  vec3 bottomRight = cross(bottom, right);
  return normalize(topRight + topLeft + bottomLeft + bottomRight);
}

float k_at(vec2 j) {
  float d = dot(getpos(j), getnormal(coord.xy));
  if(d >= 0.) {
    return 0.;
  } else {
    return 1. - dot(getnormal(coord.xy), getnormal(j));
  }
}

float crest() {
  float ret = 0.;
  float texel = 1. / res;
  ret += k_at(coord.xy + vec2(texel, 0.0));
  ret += k_at(coord.xy + vec2(-texel, 0.0));
  ret += k_at(coord.xy + vec2(0.0, -texel));
  ret += k_at(coord.xy + vec2(0.0, texel));
  return ret;
}

void main(){
  vec3 normal = getnormal(coord.xy);

  vec3 light = vec3(0., 0., 1.0);
  float diffuse = clamp(dot(normalize(light), normal), 0., 1.);

  vec3 oceancolor = vec3(0.004, 0.016, 0.047);
  vec3 skycolor = vec3(3.2, 9.6, 12.8) / 8.;

  vec3 view = normalize(gl_ModelViewMatrixInverse[3].xyz - position.xyz);

  float fresnel = 0.02 + 0.98 * pow(1.0 - dot(normal, view), 5.0);
  vec3 sky = fresnel * skycolor;

  vec3 water = (1.0 - fresnel) * skycolor * oceancolor * diffuse;
  vec3 color2 = sky + water;

  gl_FragColor = vec4(hdr(color2, 0.05) + crest() / 2., 1.);
}
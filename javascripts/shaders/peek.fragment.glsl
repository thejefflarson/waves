uniform sampler2D color;
uniform float res;
uniform float size;
varying vec4 position;
varying vec3 coord;
varying float height;

vec3 hdr (vec3 color, float exposure) {
   return 1.0 - exp(-color * exposure);
}

void main(){
  float texel = 1. / res;
  float texelSize = size / res;
  vec3 center = texture2D(color, coord.xy).rgb;
  vec3 right  = vec3(texelSize, 0.0, 0.0) + texture2D(color, coord.xy + vec2(texel, 0.0)).rgb - center;
  vec3 left   = vec3(-texelSize, 0.0, 0.0) + texture2D(color, coord.xy + vec2(-texel, 0.0)).rgb - center;
  vec3 top    = vec3(0.0, 0.0, -texelSize) + texture2D(color, coord.xy + vec2(0.0, -texel)).rgb - center;
  vec3 bottom = vec3(0.0, 0.0, texelSize) + texture2D(color, coord.xy + vec2(0.0, texel)).rgb - center;

  vec3 topRight = cross(right, top);
  vec3 topLeft = cross(top, left);
  vec3 bottomLeft = cross(left, bottom);
  vec3 bottomRight = cross(bottom, right);
  vec3 normal = normalize(topRight + topLeft + bottomLeft + bottomRight);
  vec3 light = vec3(0., 0., 1.0);
  float diffuse = clamp(dot(normalize(light), normal), 0., 1.);

  vec3 oceancolor = vec3(0.004, 0.016, 0.047);
  vec3 skycolor = vec3(3.2, 9.6, 12.8) / 8.;

  vec3 view = normalize(gl_ModelViewMatrixInverse[3].xyz + normalize(position.xyz));

  float fresnel = 0.02 + 0.98 * pow(1.0 - dot(normal, view), 5.0);
  vec3 sky = fresnel * skycolor;

  vec3 water = (1.0 - fresnel) * skycolor * oceancolor * diffuse;
  vec3 color = sky + water;

  gl_FragColor = vec4(hdr(color, 0.1), 1.);
}
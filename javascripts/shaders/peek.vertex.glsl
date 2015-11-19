uniform sampler2D color;
varying vec3 coord;
varying vec4 position;
varying float height;


void main() {
  coord = gl_TexCoord.xyz;
  vec3 coord2 = texture2D(color, vec2(gl_TexCoord)).xyz;
  height = coord2.z;
  position = vec4(gl_Vertex.xyz + coord2.xyz, 1.0);
  gl_Position = gl_ModelViewProjectionMatrix * position;
}
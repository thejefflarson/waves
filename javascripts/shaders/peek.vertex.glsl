uniform sampler2D color;
varying vec3 coord;

void main() {
  coord = texture2D(color, vec2(gl_TexCoord)).xyz;
  gl_Position = gl_ModelViewProjectionMatrix * vec4(gl_Vertex.xy + coord.xy, coord.z, 1.0);
}
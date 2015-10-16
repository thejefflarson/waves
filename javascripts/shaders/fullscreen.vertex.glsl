varying vec2 coord;

void main() {
  coord = gl_TexCoord.xy;
  gl_Position = vec4(gl_Vertex.xy, 0.0, 1.0);
}

varying vec2 coord;

void main() {
  coord = gl_TexCoord.xy;
  gl_Position = gl_Vertex;
}
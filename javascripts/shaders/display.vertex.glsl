varying vec2 coord;

void main() {
  coord = gl_TexCoord.xy;
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
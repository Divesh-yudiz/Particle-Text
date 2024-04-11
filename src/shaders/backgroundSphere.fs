precision highp float;

uniform float time;
uniform sampler2D tex;

varying vec3 vPosition;
varying vec2 vUv;
varying vec3 vColor;

float random(vec2 c){
  return fract(sin(dot(c.xy, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
  float noise = random(vUv) * 0.08;
  gl_FragColor = vec4(vColor + noise, 1.0);
}

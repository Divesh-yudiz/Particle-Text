attribute vec3 position;
attribute vec3 position2;
attribute vec2 uv;
attribute float opacity;
attribute float opacity2;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform float time;
uniform float timeTransform;
uniform float durationTransform;
uniform float prevIndex;
uniform float nextIndex;

varying vec3 vPosition;
varying vec2 vUv;
varying float vOpacity;

float exponentialOut(float t) {
  return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
}

mat4 calcRotateMat4X(float radian) {
  return mat4(
    1.0, 0.0, 0.0, 0.0,
    0.0, cos(radian), -sin(radian), 0.0,
    0.0, sin(radian), cos(radian), 0.0,
    0.0, 0.0, 0.0, 1.0
  );
}

mat4 calcRotateMat4Y(float radian) {
  return mat4(
    cos(radian), 0.0, sin(radian), 0.0,
    0.0, 1.0, 0.0, 0.0,
    -sin(radian), 0.0, cos(radian), 0.0,
    0.0, 0.0, 0.0, 1.0
  );
}

mat4 calcRotateMat4Z(float radian) {
  return mat4(
    cos(radian), -sin(radian), 0.0, 0.0,
    sin(radian), cos(radian), 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0
  );
}

mat4 calcRotateMat4(vec3 radian) {
  return calcRotateMat4X(radian.x) * calcRotateMat4Y(radian.y) * calcRotateMat4Z(radian.z);
}

void main(void) {
  // transform
  vec3 prevPosition =
    position * (1.0 - step(1.0, prevIndex))
    + position2 * step(1.0, prevIndex) * (1.0 - step(2.0, prevIndex));
  vec3 nextPosition =
    position * (1.0 - step(1.0, nextIndex))
    + position2 * step(1.0, nextIndex) * (1.0 - step(2.0, nextIndex));
  float prevOpacity =
    opacity * (1.0 - step(1.0, prevIndex))
    + opacity2 * step(1.0, prevIndex) * (1.0 - step(2.0, prevIndex));
  float nextOpacity =
    opacity * (1.0 - step(1.0, nextIndex))
    + opacity2 * step(1.0, nextIndex) * (1.0 - step(2.0, nextIndex));
  float ease = exponentialOut(min(timeTransform / 1.0, durationTransform) / durationTransform);
  vec3 mixPosition = mix(prevPosition, nextPosition, ease);
  float mixOpacity = mix(prevOpacity, nextOpacity, ease);

  // calculate shake moving.
  float now = time * 10.0 + length(mixPosition);
  mat4 rotateMat = calcRotateMat4(vec3(now));
  vec3 shake = (rotateMat * vec4(vec3(0.0, sin(now) * 5.0, 0.0), 1.0)).xyz;

  // coordinate transformation
  vec4 mvPosition = modelViewMatrix * vec4(mixPosition + shake, 1.0);

  vPosition = mixPosition;
  vUv = uv;
  vOpacity = mixOpacity;

  gl_Position = projectionMatrix * mvPosition;
}

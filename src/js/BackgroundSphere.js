import * as THREE from 'three';
import backgroundSphereVs from '../shaders/backgroundSphere.vs';
import backgroundSphereFs from '../shaders/backgroundSphere.fs';

export default class backgroundSphere {
  constructor() {
    this.uniforms = {
      time: {
        type: 'f',
        value: 0
      },
    };
    this.obj;
  }
  createObj() {
    const geometry = new THREE.SphereGeometry(10000, 128, 128);

    // Materialを定義
    const material = new THREE.RawShaderMaterial({
      uniforms: this.uniforms,
      vertexShader: backgroundSphereVs,
      fragmentShader: backgroundSphereFs,
      side: THREE.BackSide,
    });

    // Object3Dを作成
    this.obj = new THREE.Mesh(geometry, material);
  }
  render(time) {
    this.uniforms.time.value += time;
  }
}

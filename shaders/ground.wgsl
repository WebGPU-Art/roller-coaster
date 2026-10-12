#import lagopus::perspective

#import lagopus::simplex

// main

struct VertexOut {
  @builtin(position) position : vec4f,
  @location(0) original: vec3f,
};

@vertex
fn vertex_main(
  @location(0) position: vec3f,
) -> VertexOut {
  var output: VertexOut;
  let p1 = position;
  output.original = position;
  let p = transform_perspective(p1.xyz).point_position;
  let scale: f32 = 0.002;
  output.position = vec4(p[0]*scale, p[1]*scale, p[2]*scale, 1.0);
  // output.position = position;
  // output.h = 0.0;
  return output;
}

@fragment
fn fragment_main(vtx_out: VertexOut) -> @location(0) vec4f {
  let p = vtx_out.original;
  /// tricky number to make lines aligned
  let a = 0.000554;
  if (fract(p.x * a) < 0.02) {
    return vec4(1., 1., 1., 1.);
  }
  if (fract(p.z * a) < 0.02) {
    return vec4(1., 1., 1., 1.);
  }

  return vec4(0.7, 0.7, 0.7, 1.0);
  // return vec4(0., 0., 0., 1.0);
}

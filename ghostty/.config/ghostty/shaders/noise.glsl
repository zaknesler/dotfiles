const float GRAIN_SCALE = 2.0;
const float GRAIN_INTENSITY = 0.075;
const float GRAIN_SPEED = 24.0;

float hash(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * 0.1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord.xy / iResolution.xy;
  vec4 color = texture(iChannel0, uv);

  vec2 grainCoord = floor(uv * iResolution.xy / GRAIN_SCALE) * GRAIN_SCALE;
  float frame = floor(iTime * GRAIN_SPEED);
  float grain = hash(grainCoord + frame * 0.1) * 2.0 - 1.0;

  // Blend noise with the background color
  vec3 grainRGB = vec3(grain * GRAIN_INTENSITY);
  vec3 blended = mix(
    2.0 * color.rgb * (0.5 + grainRGB),
    1.0 - 2.0 * (1.0 - color.rgb) * (0.5 - grainRGB),
    step(0.5, color.rgb)
  );
  color.rgb = blended;
  fragColor = color;
}

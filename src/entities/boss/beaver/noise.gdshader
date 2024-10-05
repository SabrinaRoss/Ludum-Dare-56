shader_type canvas_item;

uniform float noise_intensity = 0.1;
uniform sampler2D texture0;

float fade(float t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float perlin_noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float a = dot(i, vec2(12, 41));
    float b = dot(i + vec2(1, 0), vec2(12, 41));
    float c = dot(i + vec2(0, 1), vec2(12, 41));
    float d = dot(i + vec2(1, 1), vec2(12, 41));

    float u = fade(f.x);
    float v = fade(f.y);

    return mix(mix(a, b, u), mix(c, d, u), v);
}

void fragment() {
    vec2 uv = UV;
    vec4 color = texture(texture0, uv);
    color.rgb += noise_intensity * perlin_noise(uv * 10.0);
    COLOR = color;
}
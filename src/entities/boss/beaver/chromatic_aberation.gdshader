shader_type canvas_item;

uniform float aberration_strength = 0.05;
uniform sampler2D texture0;

void fragment() {
    vec2 uv = UV;
    vec4 color = texture(texture0, uv);
    vec2 offset_r = uv + aberration_strength * vec2(1.0, 0.0);
    vec2 offset_g = uv;
    vec2 offset_b = uv + aberration_strength * vec2(-1.0, 0.0);
    vec3 color_r = texture(texture0, offset_r).rgb;
    vec3 color_g = texture(texture0, offset_g).rgb;
    vec3 color_b = texture(texture0, offset_b).rgb;
    color.rgb = vec3(color_r.r, color_g.g, color_b.b);
    COLOR = color;
}
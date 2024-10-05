shader_type canvas_item;

uniform float pixelation_factor = 4.0;
uniform sampler2D texture0;

void fragment() {
    vec2 uv = UV;
    uv *= pixelation_factor;
    uv = floor(uv) / pixelation_factor;
    vec4 color = texture(texture0, uv);
    COLOR = color;
}
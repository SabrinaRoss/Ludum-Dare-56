shader_type canvas_item;

uniform float vignette_intensity = 0.5;
uniform sampler2D texture0;

void fragment() {
    vec2 uv = UV;
    float distance = length(uv - vec2(0.5));
    float vignette = 1.0 - distance * distance;
    vignette = pow(vignette, vignette_intensity);
    vec4 color = texture(texture0, uv);
    color.rgb *= vignette;
    COLOR = color;
}
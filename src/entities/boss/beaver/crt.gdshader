shader_type canvas_item;

uniform float scanline_intensity = 0.5;
uniform vec2 screen_size = vec2(800.0, 600.0);
uniform sampler2D texture0;

void fragment() {
    vec2 uv = UV;

    float scanline = uv.y * screen_size.y;

    vec4 color = texture(texture0, uv);

    float scan_effect = sin(scanline * 3.14159);

    color.rgb = mix(color.rgb, vec3(0.0), scanline_intensity * (1.0 - scan_effect));

    COLOR = color;
}

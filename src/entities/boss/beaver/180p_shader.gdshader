shader_type canvas_item;

uniform int pixel_size : hint_range(1, 20) = 10;

void fragment() {
    vec2 screen_size = SCREEN_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy / screen_size;

    // Get the color from the nearest pixel
    vec4 color = texture(TEXTURE, floor(uv * pixel_size) / pixel_size);

    // Apply the pixelated color
    COLOR = color;
}
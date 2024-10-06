shader_type canvas_item;

uniform int scanline_intensity : hint_range(0, 100) = 50; // Adjustable intensity of scanlines (0 to 100)
uniform vec2 screen_size : hint_range(1, 2000) = vec2(800, 600); // Screen size as a vec2
uniform sampler2D texture0; // The texture being processed

void fragment() {
    vec2 uv = UV;

    // Calculate the actual scanline index based on UV coordinates and screen height
    float scanline = floor(uv.y * screen_size.y); // Get the scanline index
    float scan_effect = 0.5 + 0.5 * sin(scanline * 3.14159 / 2.0); // Oscillation for scanline effect

    vec4 color = texture(texture0, uv); // Get the color from the texture

    // If the texture is not found, use a fallback color
    if (color.a == 0.0) {
        color = vec4(1.0, 1.0, 1.0, 1.0); // Fallback to white if the texture is transparent
    }

    // Convert scanline intensity to a float between 0 and 1
    float intensity = float(scanline_intensity) / 100.0;

    // Apply the scanline effect by mixing with black based on intensity
    color.rgb = mix(color.rgb, vec3(0.0), intensity * (1.0 - scan_effect));

    // Set the final color
    COLOR = color;
}

